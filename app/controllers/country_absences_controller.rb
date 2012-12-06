class CountryAbsencesController < ApplicationController
  
  before_filter :check_admin
  before_filter :signed_in_user, except: [:update, :create, :destroy]
  before_filter :illegal_action, only: [:update, :create, :destroy]
  
  def index
    @country = Country.find(params[:country_id])
    @absences = @country.country_absences
    @recent_adds = CountryAbsence.total_recent(@country)
    @recent_updates = CountryAbsence.total_updated(@country)
    @recent_add_checks = CountryAbsence.recent_add_checks(@country)
    @recent_update_checks = CountryAbsence.recent_update_checks(@country)
  end
  
  def new
    @country = Country.find(params[:country_id])
    country_admin_access
    @absence = @country.country_absences.new
    @absence.updated_by = current_user.id
    @absence.checked = true if current_user.superuser?
  end
  
  def create
    @country = Country.find(params[:country_id])
    if current_user.superuser? || current_user.administrator?(@country.country)
      @absence = @country.country_absences.new(params[:country_absence])
      if @absence.save
        flash[:success] = "Absence code '#{@absence.absence_code}' has been added for #{@country.country}."
        redirect_to country_country_absences_path(@country)
      else
        @absence.updated_by = current_user.id
        @absence.checked = true if current_user.superuser?
        render 'new'
      end
    else
      flash[:notice] = "You must be a registered administrator for #{@country.country}."
      redirect_to user_path(current_user) 
    end
  end

  def edit
    @absence = CountryAbsence.find(params[:id])
    @country = Country.find(@absence.country_id)
    country_admin_access
    @absence.updated_by = current_user.id unless current_user.superuser?  #superuser check doesn't change inputter reference
  end
  
  def update
    @absence = CountryAbsence.find(params[:id])
    @country = Country.find(@absence.country_id)
    if current_user.superuser? || current_user.administrator?(@country.country)
      if @absence.update_attributes(params[:country_absence])
        @absence.update_attributes(checked: false) unless current_user.superuser?
        flash[:success] = "Absence code '#{@absence.absence_code}' for #{@country.country} has been updated."
        redirect_to country_country_absences_path(@country)
      else
        @absence.updated_by = current_user.id unless current_user.superuser?
        render 'edit'
      end
    else
      flash[:notice] = "You must be a registered administrator for #{@country.country} to make changes."
      redirect_to user_path(current_user)
    end
  end
  
  def destroy
    @absence = CountryAbsence.find(params[:id])
    @country = Country.find(@absence.country_id)
    if current_user.superuser? || current_user.administrator?(@country.country)
      @absence.destroy
      flash[:success] = "Absence code #{@absence.absence_code} for #{@country.country} destroyed."
      redirect_to country_country_absences_path(@country)
    else
      flash[:notice] = "You must be a registered administrator for #{@country.country} to make changes."
      redirect_to user_path(current_user)
    end
  end
  
  private
  
end
