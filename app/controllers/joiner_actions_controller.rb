class JoinerActionsController < ApplicationController
  before_filter :signed_in_user, except: [:update, :destroy]
  before_filter :illegal_action, only: [:update, :destroy]
  before_filter :check_admin
  
  def index
    @joinacts = JoinerAction.order("position")
    @recent_adds = JoinerAction.all_recent
    @recent_updates = JoinerAction.all_updated
    @recent_add_checks = JoinerAction.added_require_checks
    @recent_update_checks = JoinerAction.updated_require_checks
  end
  
  def sort
    params[:joiner_action].each_with_index do |id, index|
      JoinerAction.update_all({position: index+1}, {id: id})
    end
    render nothing: true
  end

  def new
    @joinact = JoinerAction.new
    @joinact.created_by = current_user.id
    @joinact.updated_by = current_user.id
    @joinact.checked = true if current_user.superuser?
  end
  
  def create
    @joinact = JoinerAction.new(params[:joiner_action])
    if @joinact.save
      flash[:success] = "'#{@joinact.action}' added"
      redirect_to joiner_actions_path
    else
      @joinact.created_by = current_user.id
      @joinact.updated_by = current_user.id
      @joinact.checked = true if current_user.superuser?
      render 'new'
    end
  end

  def edit
   @joinact = JoinerAction.find(params[:id])
   @joinact.updated_by = current_user.id unless current_user.superuser? 
  end
  
  def update
    @joinact = JoinerAction.find(params[:id])
    if @joinact.update_attributes(params[:joiner_action])
      @joinact.update_attributes(checked: false) unless current_user.superuser?
      flash[:success] = "'#{@joinact.action}' updated"
      redirect_to joiner_actions_path
    else
      @joinact.updated_by = current_user.id unless current_user.superuser? 
      render "edit"
    end
  end
  
  def destroy
    @joinact = JoinerAction.find(params[:id])
    if current_user.superuser?
      @joinact.destroy
      flash[:success]= "'#{@joinact.action}' destroyed"
      redirect_to joiner_actions_path
    else
      if @joinact.created_by == current_user.id
        @joinact.destroy
        flash[:success]= "'#{@joinact.action}' destroyed"
        redirect_to joiner_actions_path
      else
        flash[:notice] = "Illegal action.  You can only remove joiner actions you have created."
        redirect_to joiner_actions_path
      end
    end
  end
end
