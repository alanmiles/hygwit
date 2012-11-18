class JobfamiliesController < ApplicationController
  
  before_filter :signed_in_user, except: [:update, :destroy]
  before_filter :illegal_action, only: [:update, :destroy]
  before_filter :check_admin
  
  def index
    @jobfamilies = Jobfamily.all
  end

  def new
    @jobfamily = Jobfamily.new
    @jobfamily.created_by = current_user.id
    @jobfamily.approved = true if current_user.admin
  end
  
  def create
    @jobfamily = Jobfamily.new(params[:jobfamily])
    if @jobfamily.save
      flash[:success] = "'#{@jobfamily.job_family}' added"
      redirect_to jobfamilies_path
    else
      @jobfamily.created_by = current_user.id
      render 'new'
    end
  end

  def edit
   @jobfamily = Jobfamily.find(params[:id])
  end
  
  def update
    @jobfamily = Jobfamily.find(params[:id])
    if @jobfamily.update_attributes(params[:jobfamily])
      flash[:success] = "'#{@jobfamily.job_family}' updated"
      redirect_to jobfamilies_path
    else
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
