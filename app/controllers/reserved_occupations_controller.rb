class ReservedOccupationsController < ApplicationController
  
  before_filter :check_admin
  before_filter :signed_in_user, except: [:update, :create, :destroy]
  before_filter :illegal_action, only: [:update, :create, :destroy]
  
  def index
    @country = Country.find(params[:country_id])
    check_permitted
    @occupations = @country.reserved_occupations.all
    @recent_adds = ReservedOccupation.total_recent(@country)
    @recent_updates = ReservedOccupation.total_updated(@country)
    @recent_add_checks = ReservedOccupation.recent_add_checks(@country)
    @recent_update_checks = ReservedOccupation.recent_update_checks(@country)
  end
  
  def new
    @country = Country.find(params[:country_id]) 
    country_admin_access
    check_permitted
    @occupation = @country.reserved_occupations.new
    @available_jobs = Jobfamily.non_reserved_jobs(@country)
    @occupation.created_by = current_user.id
    @occupation.updated_by = current_user.id
    @occupation.checked = true if current_user.superuser?
    @edit = false
  end
  
  def create
    @country = Country.find(params[:country_id])
    check_permitted
    if current_user.superuser? || current_user.administrator?(@country.country)
      @occupation = @country.reserved_occupations.new(params[:reserved_occupation])
      if @occupation.save
        flash[:success] = "'#{@occupation.jobfamily.job_family}' has been added to the reserved occupations list."
        redirect_to country_reserved_occupations_path(@country)
      else
        @edit = false
        @occupation.created_by = current_user.id
        @occupation.updated_by = current_user.id
        @occupation.checked = true if current_user.superuser?
        @available_jobs = Jobfamily.non_reserved_jobs(@country)
        render 'new'
      end
    else
      flash[:notice] = "You must be a registered administrator for #{@country.country}."
      redirect_to user_path(current_user) 
    end
  end

  def edit
    @occupation = ReservedOccupation.find(params[:id])
    @country = Country.find(@occupation.country_id)
    country_admin_access
    disallow_edit
    @occupation.updated_by = current_user.id unless current_user.superuser?
    @edit = true 
  end
  
  def update
    @occupation = ReservedOccupation.find(params[:id])
    @country = Country.find(@occupation.country_id)
    disallow_edit
    if current_user.superuser? || current_user.administrator?(@country.country)
      if @occupation.update_attributes(params[:reserved_occupation])
        @occupation.update_attributes(checked: false) unless current_user.superuser?
        flash[:success] = "'#{@occupation.jobfamily.job_family}' has been edited."
        redirect_to country_reserved_occupations_path(@country)
      else
        @edit = true
        @occupation.updated_by = current_user.id unless current_user.superuser? 
        render 'edit'
      end
    else
      flash[:notice] = "You must be a registered administrator for #{@country.country} to make changes."
      redirect_to user_path(current_user)
    end
  end
  
  def destroy
    @occupation = ReservedOccupation.find(params[:id])
    @country = Country.find(@occupation.country_id)
    if current_user.superuser? || current_user.administrator?(@country.country)
      @occupation.destroy
      flash[:success] = "'#{@occupation.jobfamily.job_family}' has been removed from the reserved occupations list."
      redirect_to country_reserved_occupations_path(@country)
    else
      flash[:notice] = "You must be a registered administrator for #{@country.country} to make changes."
      redirect_to user_path(current_user)
    end
  end
  
  private
    
    def check_permitted
      unless @country.reserved_jobs?
        flash[:notice] = "No occupations are reserved for nationals in this country."
        redirect_to user_path(current_user)
      end
    end
    
    def disallow_edit
      unless current_user.superuser?
        if current_user.administrator?(@country.country)
          flash[:notice] = "You're not allowed to edit a Reserved Occupation - but you could delete it instead."
          redirect_to country_reserved_occupations_path(@country)   
        end
      end
    end
end
