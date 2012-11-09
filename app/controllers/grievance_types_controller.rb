class GrievanceTypesController < ApplicationController
 
  before_filter :signed_in_user, except: [:update, :destroy]
  before_filter :illegal_action, only: [:update, :destroy]
  before_filter :check_admin
  
  def index
    @grievance_types = GrievanceType.all
  end

  def new
    @grievance_type = GrievanceType.new
  end
  
  def create
    @grievance_type = GrievanceType.new(params[:grievance_type])
    if @grievance_type.save
      flash[:success] = "'#{@grievance_type.grievance}' added"
      redirect_to grievance_types_path
    else
      render 'new'
    end
  end

  def edit
   @grievance_type = GrievanceType.find(params[:id])
  end
  
  def update
    @grievance_type = GrievanceType.find(params[:id])
    if @grievance_type.update_attributes(params[:grievance_type])
      flash[:success] = "'#{@grievance_type.grievance}' updated"
      redirect_to grievance_types_path
    else
      render "edit"
    end
  end
  
  def destroy
    @grievance_type = GrievanceType.find(params[:id]).destroy
    flash[:success]= "'#{@grievance_type.grievance}' destroyed"
    redirect_to grievance_types_path
  end
  
end
