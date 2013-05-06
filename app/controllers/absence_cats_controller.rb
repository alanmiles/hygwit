class AbsenceCatsController < ApplicationController
  
  before_filter :signed_in_user, except: [:update, :create, :destroy]
  before_filter :illegal_action, only: [:update, :create, :destroy]
  
  def index
    @business = Business.find(params[:business_id])
    check_bizadmin
    @absence_cats = @business.current_absence_cats
  end

  def new
    @business = Business.find(params[:business_id])
    check_bizadmin
    @absence_cat = @business.absence_cats.new
    @absence_cat.created_by = current_user.id
    @absence_cat.updated_by = current_user.id
    @formtype = "new"
  end
  
  def create
    @business = Business.find(params[:business_id])
    if current_user.bizadmin?(@business)
      @absence_cat = @business.absence_cats.new(params[:absence_cat])
      if @absence_cat.save
        flash[:success] = "'#{@absence_cat.absence_code}' has been added."
        redirect_to business_absence_cats_path(@business)
      else
        @absence_cat.created_by = current_user.id
        @absence_cat.updated_by = current_user.id
        render 'new'
        @formtype = "new"
      end
    else
      flash[:notice] = "Sorry, you're not a registered officer for #{@business.name}."
      redirect_to user_path(current_user)
    end
  end

  def edit
    @absence_cat = AbsenceCat.find(params[:id])
    @absence_cat.updated_by = current_user.id
    @business = Business.find(@absence_cat.business_id)
    check_bizadmin
    @formtype = "edit"
  end
  
  def update
    @absence_cat = AbsenceCat.find(params[:id])
    @business = Business.find(@absence_cat.business_id)
    if current_user.bizadmin?(@business)
      if @absence_cat.update_attributes(params[:absence_cat])
        flash[:success] = "'#{@absence_cat.absence_code}' has been updated."
        redirect_to business_absence_cats_path(@business)
      else
        @absence_cat.updated_by = current_user.id
        render 'edit'
        @formtype = "edit"
      end
    else
      flash[:notice] = "Sorry, you're not a registered officer for #{@business.name}."
      redirect_to user_path(current_user)
    end    
  end
  
  def destroy
    @absence_cat = AbsenceCat.find(params[:id])
    @business = Business.find(@absence_cat.business_id)
    if current_user.bizadmin?(@business)
      @absence_cat.destroy
      flash[:success] = "'#{@absence_cat.absence_code}' has been deleted."
      redirect_to business_absence_cats_path(@business)
    else
      flash[:notice] = "Sorry, you're not a registered officer for #{@business.name}."
      redirect_to user_path(current_user)
    end
  end
end
