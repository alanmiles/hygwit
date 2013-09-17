class LeaverActivitiesController < ApplicationController
  before_filter :signed_in_user, except: [:update, :create, :destroy]
  before_filter :illegal_action, only: [:update, :create, :destroy]
  
  def index
    @business = Business.find(params[:business_id])
    check_bizadmin
    @leaver_activities = @business.leaver_activities
  end
  
  def sort
    params[:leaver_activity].each_with_index do |id, index|
      LeaverActivity.update_all({position: index+1}, {id: id})
    end
    render nothing: true
  end

  def new
    @business = Business.find(params[:business_id])
    check_bizadmin
    @leaver_activity = @business.leaver_activities.new
    @leaver_activity.created_by = current_user.id
    @leaver_activity.updated_by = current_user.id
  end
  
  def create
    @business = Business.find(params[:business_id])
    if current_user.bizadmin?(@business)
      @leaver_activity = @business.leaver_activities.new(params[:leaver_activity])
      if @leaver_activity.save
        flash[:success] = "'#{@leaver_activity.action}' has been added."
        redirect_to business_leaver_activities_path(@business)
      else
        @leaver_activity.created_by = current_user.id
        @leaver_activity.updated_by = current_user.id
        render 'new'
      end
    else
      flash[:notice] = "Sorry, you're not a registered officer for #{@business.name}."
      redirect_to user_path(current_user)
    end
  end

  def edit
    @leaver_activity = LeaverActivity.find(params[:id])
    @leaver_activity.updated_by = current_user.id
    @business = Business.find(@leaver_activity.business_id)
    check_bizadmin
  end
  
  def update
    @leaver_activity = LeaverActivity.find(params[:id])
    @business = Business.find(@leaver_activity.business_id)
    if current_user.bizadmin?(@business)
      if @leaver_activity.update_attributes(params[:leaver_activity])
        flash[:success] = "'#{@leaver_activity.action}' has been updated."
        redirect_to business_leaver_activities_path(@business)
      else
        @leaver_activity.updated_by = current_user.id
        render 'edit'
      end
    else
      flash[:notice] = "Sorry, you're not a registered officer for #{@business.name}."
      redirect_to user_path(current_user)
    end    
  end
  
  def destroy
    @leaver_activity = LeaverActivity.find(params[:id])
    @business = Business.find(@leaver_activity.business_id)
    if current_user.bizadmin?(@business)
      @leaver_activity.destroy
      flash[:success] = "'#{@leaver_activity.action}' has been deleted."
      redirect_to business_leaver_activities_path(@business)
    else
      flash[:notice] = "Sorry, you're not a registered officer for #{@business.name}."
      redirect_to user_path(current_user)
    end
  end
end
