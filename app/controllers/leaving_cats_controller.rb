class LeavingCatsController < ApplicationController
  
  before_filter :signed_in_user, except: [:update, :create, :destroy]
  before_filter :illegal_action, only: [:update, :create, :destroy]
  
  def index
    @business = Business.find(params[:business_id])
    check_bizadmin
    @leaving_cats = @business.leaving_cats
  end

  def new
    @business = Business.find(params[:business_id])
    check_bizadmin
    @leaving_cat = @business.leaving_cats.new
    @leaving_cat.created_by = current_user.id
    @leaving_cat.updated_by = current_user.id
  end
  
  def create
    @business = Business.find(params[:business_id])
    if current_user.bizadmin?(@business)
      @leaving_cat = @business.leaving_cats.new(params[:leaving_cat])
      if @leaving_cat.save
        flash[:success] = "'#{@leaving_cat.reason}' has been added."
        redirect_to business_leaving_cats_path(@business)
      else
        @leaving_cat.created_by = current_user.id
        @leaving_cat.updated_by = current_user.id
        render 'new'
      end
    else
      flash[:notice] = "Sorry, you're not a registered officer for #{@business.name}."
      redirect_to user_path(current_user)
    end
  end

  def edit
    @leaving_cat = LeavingCat.find(params[:id])
    @leaving_cat.updated_by = current_user.id
    @business = Business.find(@leaving_cat.business_id)
    check_bizadmin
  end
  
  def update
    @leaving_cat = LeavingCat.find(params[:id])
    @business = Business.find(@leaving_cat.business_id)
    if current_user.bizadmin?(@business)
      if @leaving_cat.update_attributes(params[:leaving_cat])
        flash[:success] = "'#{@leaving_cat.reason}' has been updated."
        redirect_to business_leaving_cats_path(@business)
      else
        @leaving_cat.updated_by = current_user.id
        render 'edit'
      end
    else
      flash[:notice] = "Sorry, you're not a registered officer for #{@business.name}."
      redirect_to user_path(current_user)
    end    
  end
  
  def destroy
    @leaving_cat = LeavingCat.find(params[:id])
    @business = Business.find(@leaving_cat.business_id)
    if current_user.bizadmin?(@business)
      @leaving_cat.destroy
      flash[:success] = "'#{@leaving_cat.reason}' has been deleted."
      redirect_to business_leaving_cats_path(@business)
    else
      flash[:notice] = "Sorry, you're not a registered officer for #{@business.name}."
      redirect_to user_path(current_user)
    end
  end
end
