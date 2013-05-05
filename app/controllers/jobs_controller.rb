class JobsController < ApplicationController
  
  before_filter :signed_in_user, except: [:update, :create, :destroy]
  before_filter :illegal_action, only: [:update, :create, :destroy]
  
  def index
    @business = Business.find(params[:business_id])
    check_bizadmin
    @jobs = @business.current_jobs.paginate(page: params[:page])
  end

  def new
    @business = Business.find(params[:business_id])
    check_bizadmin
    @job = @business.jobs.new
    @jobfamilies = Jobfamily.where(checked: true)
    @departments = @business.current_departments
    @rank_cats = @business.rank_cats
    @job.created_by = current_user.id
    @job.updated_by = current_user.id
    @formtype = "new"
  end
  
  def create
    @business = Business.find(params[:business_id])
    if current_user.bizadmin?(@business)
      @job = @business.jobs.new(params[:job])
      if @job.save
        flash[:success] = "'#{@job.job_title}' has been added."
        redirect_to business_jobs_path(@business)
      else
        @job.created_by = current_user.id
        @job.updated_by = current_user.id
        @jobfamilies = Jobfamily.where(checked: true)
        @departments = @business.current_departments
        @rank_cats = @business.rank_cats
        render 'new'
        @formtype = "new"
      end
    else
      flash[:notice] = "Sorry, you're not a registered officer for #{@business.name}."
      redirect_to user_path(current_user)
    end
  end

  def edit
    @job = Job.find(params[:id])
    @job.updated_by = current_user.id
    @business = Business.find(@job.business_id)
    check_bizadmin
    @jobfamilies = Jobfamily.where(checked: true)
    @departments = @business.current_departments
    @rank_cats = @business.rank_cats
    @formtype = "edit"
  end
  
  def update
    @job = Job.find(params[:id])
    @business = Business.find(@job.business_id)
    if current_user.bizadmin?(@business)
      if @job.update_attributes(params[:job])
        flash[:success] = "'#{@job.job_title}' has been updated."
        redirect_to business_jobs_path(@business)
      else
        @job.updated_by = current_user.id
        @jobfamilies = Jobfamily.where(checked: true)
        @departments = @business.current_departments
        @rank_cats = @business.rank_cats
        render 'edit'
        @formtype = "edit"
      end
    else
      flash[:notice] = "Sorry, you're not a registered officer for #{@business.name}."
      redirect_to user_path(current_user)
    end    
  end
  
  def destroy
    @job = Job.find(params[:id])
    @business = Business.find(@job.business_id)
    if current_user.bizadmin?(@business)
      @job.destroy
      flash[:success] = "'#{@job.job_title}' has been deleted."
      redirect_to business_jobs_path(@business)
    else
      flash[:notice] = "Sorry, you're not a registered officer for #{@business.name}."
      redirect_to user_path(current_user)
    end
  end
end
