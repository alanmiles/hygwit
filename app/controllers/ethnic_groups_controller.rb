class EthnicGroupsController < ApplicationController
  
  before_filter :signed_in_user, except: [:update, :create, :destroy]
  before_filter :illegal_action, only: [:update, :create, :destroy]
  before_filter :check_admin
  
  def index
    @country = Country.find(params[:country_id])
    check_permitted
    @egroups = @country.ethnic_groups.all
    @recent_adds = EthnicGroup.total_recent(@country)
    @recent_updates = EthnicGroup.total_updated(@country)
    @recent_add_checks = EthnicGroup.recent_add_checks(@country)
    @recent_update_checks = EthnicGroup.recent_update_checks(@country)
  end
  
  def new
    @country = Country.find(params[:country_id]) 
    country_admin_access
    check_permitted
    @egroup = @country.ethnic_groups.new
    @egroup.created_by = current_user.id
    @egroup.updated_by = current_user.id
    @egroup.checked = true if current_user.superuser?
    @edit = false
  end
  
  def create
    @country = Country.find(params[:country_id])
    check_permitted
    if current_user.superuser? || current_user.administrator?(@country.country)
      @egroup = @country.ethnic_groups.new(params[:ethnic_group])
      if @egroup.save
        flash[:success] = "'#{@egroup.ethnic_group}' has been added."
        redirect_to country_ethnic_groups_path(@country)
      else
        @edit = false
        @egroup.created_by = current_user.id
        @egroup.updated_by = current_user.id
        @egroup.checked = true if current_user.superuser?
        render 'new'
      end
    else
      flash[:notice] = "You must be a registered administrator for #{@country.country}."
      redirect_to user_path(current_user) 
    end
  end

  def edit
    @egroup = EthnicGroup.find(params[:id])
    @country = Country.find(@egroup.country_id)
    country_admin_access
    @egroup.updated_by = current_user.id unless current_user.superuser?
    @edit = true 
  end
  
  def update
    @egroup = EthnicGroup.find(params[:id])
    @country = Country.find(@egroup.country_id)
    if current_user.superuser? || current_user.administrator?(@country.country)
      if @egroup.update_attributes(params[:ethnic_group])
        @egroup.update_attributes(checked: false) unless current_user.superuser?
        flash[:success] = "'#{@egroup.ethnic_group}' has been edited."
        redirect_to country_ethnic_groups_path(@country)
      else
        @edit = true
        @egroup.updated_by = current_user.id unless current_user.superuser? 
        render 'edit'
      end
    else
      flash[:notice] = "You must be a registered administrator for #{@country.country} to make changes."
      redirect_to user_path(current_user)
    end
  end
  
  def destroy
    @egroup = EthnicGroup.find(params[:id])
    @country = Country.find(@egroup.country_id)
    if current_user.superuser? || current_user.administrator?(@country.country)
      @egroup.destroy
      flash[:success] = "'#{@egroup.ethnic_group}' has been removed from the ethnic groups table for #{@country.country}."
      redirect_to country_ethnic_groups_path(@country)
    else
      flash[:notice] = "You must be a registered administrator for #{@country.country} to make changes."
      redirect_to user_path(current_user)
    end
  end
  
  private
    
    def check_permitted
      unless @country.ethnicity_reports?
        flash[:notice] = "Reports on employee ethnicity are not required in this country."
        redirect_to user_path(current_user)
      end
    end
end
