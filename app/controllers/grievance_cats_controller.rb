class GrievanceCatsController < ApplicationController
  before_filter :signed_in_user, except: [:update, :create, :destroy]
  before_filter :illegal_action, only: [:update, :create, :destroy]
  
  def index
    @business = Business.find(params[:business_id])
    check_bizadmin
    @grievance_cats = @business.grievance_cats
  end

  def new
    @business = Business.find(params[:business_id])
    check_bizadmin
    @grievance_cat = @business.grievance_cats.new
    @grievance_cat.created_by = current_user.id
    @grievance_cat.updated_by = current_user.id
  end
  
  def create
    @business = Business.find(params[:business_id])
    if current_user.bizadmin?(@business)
      @grievance_cat = @business.grievance_cats.new(params[:grievance_cat])
      if @grievance_cat.save
        flash[:success] = "'#{@grievance_cat.grievance}' has been added."
        redirect_to business_grievance_cats_path(@business)
      else
        @grievance_cat.created_by = current_user.id
        @grievance_cat.updated_by = current_user.id
        render 'new'
      end
    else
      flash[:notice] = "Sorry, you're not a registered officer for #{@business.name}."
      redirect_to user_path(current_user)
    end
  end

  def edit
    @grievance_cat = GrievanceCat.find(params[:id])
    @grievance_cat.updated_by = current_user.id
    @business = Business.find(@grievance_cat.business_id)
    check_bizadmin
  end
  
  def update
    @grievance_cat = GrievanceCat.find(params[:id])
    @business = Business.find(@grievance_cat.business_id)
    if current_user.bizadmin?(@business)
      if @grievance_cat.update_attributes(params[:grievance_cat])
        flash[:success] = "'#{@grievance_cat.grievance}' has been updated."
        redirect_to business_grievance_cats_path(@business)
      else
        @grievance_cat.updated_by = current_user.id
        render 'edit'
      end
    else
      flash[:notice] = "Sorry, you're not a registered officer for #{@business.name}."
      redirect_to user_path(current_user)
    end    
  end
  
  def destroy
    @grievance_cat = GrievanceCat.find(params[:id])
    @business = Business.find(@grievance_cat.business_id)
    if current_user.bizadmin?(@business)
      @grievance_cat.destroy
      flash[:success] = "'#{@grievance_cat.grievance}' has been deleted."
      redirect_to business_grievance_cats_path(@business)
    else
      flash[:notice] = "Sorry, you're not a registered officer for #{@business.name}."
      redirect_to user_path(current_user)
    end
  end
end
