class JobfamiliesController < ApplicationController
  
  before_filter :signed_in_user, except: [:update, :destroy]
  before_filter :illegal_action, only: [:update, :destroy]
  before_filter :check_admin
  
  def index
    @jobfamilies = Jobfamily.all
    @recent_adds = Jobfamily.all_recent
    @recent_updates = Jobfamily.all_updated
    @recent_add_checks = Jobfamily.added_require_checks
    @recent_update_checks = Jobfamily.updated_require_checks
  end

  def new
    @jobfamily = Jobfamily.new
    @jobfamily.created_by = current_user.id
    @jobfamily.updated_by = current_user.id
    @jobfamily.checked = true if current_user.superuser?
  end
  
  def create
    @jobfamily = Jobfamily.new(params[:jobfamily])
    if @jobfamily.save
      flash[:success] = "'#{@jobfamily.job_family}' added"
      redirect_to jobfamilies_path
    else
      @jobfamily.created_by = current_user.id
      @jobfamily.updated_by = current_user.id
      @jobfamily.checked = true if current_user.superuser?
      render 'new'
    end
  end

  def edit
   @jobfamily = Jobfamily.find(params[:id])
   @jobfamily.updated_by = current_user.id unless current_user.superuser? 
  end
  
  def update
    @jobfamily = Jobfamily.find(params[:id])
    if @jobfamily.update_attributes(params[:jobfamily])
      @jobfamily.update_attributes(checked: false) unless current_user.superuser?
      flash[:success] = "'#{@jobfamily.job_family}' updated"
      redirect_to jobfamilies_path
    else
      @jobfamily.updated_by = current_user.id unless current_user.superuser? 
      render "edit"
    end
  end
  
  def destroy
    @jobfamily = Jobfamily.find(params[:id])
    if current_user.superuser?
      @jobfamily.destroy
      flash[:success]= "'#{@jobfamily.job_family}' destroyed"
      redirect_to jobfamilies_path
    else
      if @jobfamily.created_by == current_user.id
        @jobfamily.destroy
        flash[:success]= "'#{@jobfamily.job_family}' destroyed"
        redirect_to jobfamilies_path
      else
        flash[:notice] = "Illegal action.  You can only remove job families you have created."
        redirect_to jobfamilies_path
      end
    end
  end
end
