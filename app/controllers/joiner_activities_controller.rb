class JoinerActivitiesController < ApplicationController
  before_filter :signed_in_user, except: [:update, :create, :destroy]
  before_filter :illegal_action, only: [:update, :create, :destroy]
  
  def index
    @business = Business.find(params[:business_id])
    check_bizadmin
    @joiner_activities = @business.joiner_activities
  end
  
  def sort
    params[:joiner_activity].each_with_index do |id, index|
      JoinerActivity.update_all({position: index+1}, {id: id})
    end
    render nothing: true
  end

  def new
    @business = Business.find(params[:business_id])
    check_bizadmin
    @joiner_activity = @business.joiner_activities.new
    @joiner_activity.created_by = current_user.id
    @joiner_activity.updated_by = current_user.id
  end
  
  def create
    @business = Business.find(params[:business_id])
    if current_user.bizadmin?(@business)
      @joiner_activity = @business.joiner_activities.new(params[:joiner_activity])
      if @joiner_activity.save
        flash[:success] = "'#{@joiner_activity.action}' has been added."
        redirect_to business_joiner_activities_path(@business)
      else
        @joiner_activity.created_by = current_user.id
        @joiner_activity.updated_by = current_user.id
        render 'new'
      end
    else
      flash[:notice] = "Sorry, you're not a registered officer for #{@business.name}."
      redirect_to user_path(current_user)
    end
  end

  def edit
    @joiner_activity = JoinerActivity.find(params[:id])
    @joiner_activity.updated_by = current_user.id
    @business = Business.find(@joiner_activity.business_id)
    check_bizadmin
  end
  
  def update
    @joiner_activity = JoinerActivity.find(params[:id])
    @business = Business.find(@joiner_activity.business_id)
    if current_user.bizadmin?(@business)
      if @joiner_activity.update_attributes(params[:joiner_activity])
        flash[:success] = "'#{@joiner_activity.action}' has been updated."
        redirect_to business_joiner_activities_path(@business)
      else
        @joiner_activity.updated_by = current_user.id
        render 'edit'
      end
    else
      flash[:notice] = "Sorry, you're not a registered officer for #{@business.name}."
      redirect_to user_path(current_user)
    end    
  end
  
  def destroy
    @joiner_activity = JoinerActivity.find(params[:id])
    @business = Business.find(@joiner_activity.business_id)
    if current_user.bizadmin?(@business)
      @joiner_activity.destroy
      flash[:success] = "'#{@joiner_activity.action}' has been deleted."
      redirect_to business_joiner_activities_path(@business)
    else
      flash[:notice] = "Sorry, you're not a registered officer for #{@business.name}."
      redirect_to user_path(current_user)
    end
  end
end
