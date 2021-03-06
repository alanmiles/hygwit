class CountriesController < ApplicationController
  
  before_filter :signed_in_user, except: [:update, :destroy]
  before_filter :illegal_action, only: [:update, :destroy]
  before_filter :check_admin
  before_filter :check_superuser, only: :new
  
  def index
    @countries = Country.all
    @recent_adds = Country.all_recent
    @recent_updates = Country.all_updated
    @recent_add_checks = Country.added_require_checks
    @recent_update_checks = Country.updated_require_checks
  end
  
  def show
    @country = Country.find(params[:id])
    @absences = @country.country_absences
  end

  def new
    @country = Country.new
    @nationalities = Nationality.all
    @currencies = Currency.all
    @country.created_by = current_user.id
    @country.updated_by = current_user.id
    @country.checked = true if current_user.superuser?
  end
  
  def create
    @country = Country.new(params[:country])
    if @country.save
      flash[:success] = "'#{@country.country}' added"
      redirect_to @country
    else
      @nationalities = Nationality.all
      @currencies = Currency.all
      @country.created_by = current_user.id
      @country.updated_by = current_user.id
      @country.checked = true if current_user.superuser?
      render 'new'
    end
  end

  def edit
   @country = Country.find(params[:id])
   country_admin_access
   @nationalities = Nationality.all
   @currencies = Currency.all
   @country.updated_by = current_user.id unless current_user.superuser? 
  end
  
  def update
    @country= Country.find(params[:id])
    if current_user.superuser? || current_user.administrator?(@country.country)
      params[:country].parse_time_select! :nightwork_start
      params[:country].parse_time_select! :nightwork_end
      if @country.update_attributes(params[:country])
        @country.update_attributes(checked: false) unless current_user.superuser?
        flash[:success] = "'#{@country.country}' updated"
        redirect_to @country
      else
        @nationalities = Nationality.all
        @currencies = Currency.all
        @country.updated_by = current_user.id unless current_user.superuser? 
        render "edit"
      end
    else
      flash[:notice] = "You must be a registered administrator for #{@country.country} to make changes."
      redirect_to user_path(current_user)
    end
  end
  
  def destroy
    @country = Country.find(params[:id])
    if current_user.superuser?
      @country.destroy
      flash[:success]= "'#{@country.country}' destroyed"
      redirect_to countries_path
    else
      if @country.created_by == current_user.id
        @country.destroy
        flash[:success]= "'#{@country.country}' destroyed"
        redirect_to countries_path
      else
        flash[:notice] = "Illegal action.  You can only remove countries you have created."
        redirect_to countries_path
      end
    end
  end
  
  def insurance_menu
    @country = Country.find(params[:id])
    session[:group_focus] = nil
    session[:time_focus] = nil
    session[:insurance_date] = nil
  end
  
end
