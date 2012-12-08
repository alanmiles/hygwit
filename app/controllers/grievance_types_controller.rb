class GrievanceTypesController < ApplicationController
 
  before_filter :signed_in_user, except: [:update, :destroy]
  before_filter :illegal_action, only: [:update, :destroy]
  before_filter :check_admin
  
  def index
    @grievance_types = GrievanceType.all
    @recent_adds = GrievanceType.all_recent
    @recent_updates = GrievanceType.all_updated
    @recent_add_checks = GrievanceType.added_require_checks
    @recent_update_checks = GrievanceType.updated_require_checks
  end

  def new
    @grievance_type = GrievanceType.new
    @grievance_type.created_by = current_user.id
    @grievance_type.updated_by = current_user.id
    @grievance_type.checked = true if current_user.superuser?
  end
  
  def create
    @grievance_type = GrievanceType.new(params[:grievance_type])
    if @grievance_type.save
      flash[:success] = "'#{@grievance_type.grievance}' added"
      redirect_to grievance_types_path
    else
      @grievance_type.created_by = current_user.id
      @grievance_type.updated_by = current_user.id
      @grievance_type.checked = true if current_user.superuser?
      render 'new'
    end
  end

  def edit
    @grievance_type = GrievanceType.find(params[:id])
    @grievance_type.updated_by = current_user.id unless current_user.superuser? 
  end
  
  def update
    @grievance_type = GrievanceType.find(params[:id])
    if @grievance_type.update_attributes(params[:grievance_type])
      @grievance_type.update_attributes(checked: false) unless current_user.superuser?
      flash[:success] = "'#{@grievance_type.grievance}' updated"
      redirect_to grievance_types_path
    else
      @grievance_type.updated_by = current_user.id unless current_user.superuser?
      render "edit"
    end
  end
  
  def destroy
    @grievance_type = GrievanceType.find(params[:id])
    if current_user.superuser?
      @grievance_type.destroy
      flash[:success]= "'#{@grievance_type.grievance}' destroyed"
      redirect_to grievance_types_path
    else
      if @grievance_type.created_by == current_user.id
        @grievance_type.destroy
        flash[:success]= "'#{@grievance_type.grievance}' destroyed"
        redirect_to grievance_types_path
      else
        flash[:notice] = "Illegal action.  You can only remove grievance types you have created."
        redirect_to grievance_types_path
      end
    end 
  end
  
end
