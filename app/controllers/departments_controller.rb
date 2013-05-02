class DepartmentsController < ApplicationController
  
  before_filter :signed_in_user, except: [:update, :create, :destroy]
  before_filter :illegal_action, only: [:update, :create, :destroy]
  
  def index
    @business = Business.find(params[:business_id])
    check_bizadmin
    @departments = @business.current_departments
  end

  def new
    @business = Business.find(params[:business_id])
    check_bizadmin
    @department = @business.departments.new
    @department.created_by = current_user.id
    @department.updated_by = current_user.id
    @divisions = @business.current_divisions
    @formtype = "new"
  end
  
  def create
    @business = Business.find(params[:business_id])
    if current_user.bizadmin?(@business)
      @department = @business.departments.new(params[:department])
      if @department.save
        flash[:success] = "'#{@department.department}' has been added."
        redirect_to business_departments_path(@business)
      else
        @department.created_by = current_user.id
        @department.updated_by = current_user.id
        @divisions = @business.current_divisions
        render 'new'
        @formtype = "new"
      end
    else
      flash[:notice] = "Sorry, you're not a registered officer for #{@business.name}."
      redirect_to user_path(current_user)
    end
  end

  def edit
    @department = Department.find(params[:id])
    @department.updated_by = current_user.id
    @business = Business.find(@department.business_id)
    check_bizadmin
    @divisions = @business.current_divisions
    @formtype = "edit"
  end
  
  def update
    @department = Department.find(params[:id])
    @business = Business.find(@department.business_id)
    if current_user.bizadmin?(@business)
      if @department.update_attributes(params[:department])
        flash[:success] = "'#{@department.department}' has been updated."
        redirect_to business_departments_path(@business)
      else
        @department.updated_by = current_user.id
        @divisions = @business.current_divisions
        render 'edit'
        @formtype = "edit"
      end
    else
      flash[:notice] = "Sorry, you're not a registered officer for #{@business.name}."
      redirect_to user_path(current_user)
    end    
  end
  
  def destroy
    @department = Department.find(params[:id])
    @business = Business.find(@department.business_id)
    if current_user.bizadmin?(@business)
      @department.destroy
      flash[:success] = "The '#{@department.department}' department has been deleted."
      redirect_to business_departments_path(@business)
    else
      flash[:notice] = "Sorry, you're not a registered officer for #{@business.name}."
      redirect_to user_path(current_user)
    end
  end
end
