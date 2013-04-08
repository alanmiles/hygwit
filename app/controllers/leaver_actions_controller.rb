class LeaverActionsController < ApplicationController
  before_filter :signed_in_user, except: [:update, :destroy]
  before_filter :illegal_action, only: [:update, :destroy]
  before_filter :check_admin
  
  def index
    @leaveacts = LeaverAction.order("position")
    @recent_adds = LeaverAction.all_recent
    @recent_updates = LeaverAction.all_updated
    @recent_add_checks = LeaverAction.added_require_checks
    @recent_update_checks = LeaverAction.updated_require_checks
  end
  
  def sort
    params[:leaver_action].each_with_index do |id, index|
      LeaverAction.update_all({position: index+1}, {id: id})
    end
    render nothing: true
  end

  def new
    @leaveact = LeaverAction.new
    @leaveact.created_by = current_user.id
    @leaveact.updated_by = current_user.id
    @leaveact.checked = true if current_user.superuser?
  end
  
  def create
    @leaveact = LeaverAction.new(params[:leaver_action])
    if @leaveact.save
      flash[:success] = "'#{@leaveact.action}' added"
      redirect_to leaver_actions_path
    else
      @leaveact.created_by = current_user.id
      @leaveact.updated_by = current_user.id
      @leaveact.checked = true if current_user.superuser?
      render 'new'
    end
  end

  def edit
   @leaveact = LeaverAction.find(params[:id])
   @leaveact.updated_by = current_user.id unless current_user.superuser? 
  end
  
  def update
    @leaveact = LeaverAction.find(params[:id])
    if @leaveact.update_attributes(params[:leaver_action])
      @leaveact.update_attributes(checked: false) unless current_user.superuser?
      flash[:success] = "'#{@leaveact.action}' updated"
      redirect_to leaver_actions_path
    else
      @leaveact.updated_by = current_user.id unless current_user.superuser? 
      render "edit"
    end
  end
  
  def destroy
    @leaveact = LeaverAction.find(params[:id])
    if current_user.superuser?
      @leaveact.destroy
      flash[:success]= "'#{@leaveact.action}' destroyed"
      redirect_to leaver_actions_path
    else
      if @leaveact.created_by == current_user.id
        @leaveact.destroy
        flash[:success]= "'#{@leaveact.action}' destroyed"
        redirect_to leaver_actions_path
      else
        flash[:notice] = "Illegal action.  You can only remove leaver actions you have created."
        redirect_to leaver_actions_path
      end
    end
  end
end
