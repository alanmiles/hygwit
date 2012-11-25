class CountryAbsencesController < ApplicationController
  
  before_filter :check_admin
  before_filter :signed_in_user, except: [:update, :create, :destroy]
  before_filter :illegal_action, only: [:update, :create, :destroy]
  
  def index
    @country = Country.find(params[:country_id])
    @absences = @country.country_absences
    @recent_adds = CountryAbsence.total_recent(@country)
    @recent_updates = CountryAbsence.total_updated(@country)
  end
  
  def new
    @country = Country.find(params[:country_id])
    country_admin_access
    @absence = @country.country_absences.new
    @absence.created_by = current_user.id
  end
  
  def create
    @country = Country.find(params[:country_id])
    if current_user.superuser? || current_user.administrator?(@country.country)
      @absence = @country.country_absences.new(params[:country_absence])
      if @absence.save
        flash[:success] = "Absence code '#{@absence.absence_code}' has been added for #{@country.country}."
        redirect_to country_country_absences_path(@country)
      else
        @absence.created_by = current_user.id
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
  end
  
  def update
    @absence = CountryAbsence.find(params[:id])
    @country = Country.find(@absence.country_id)
    if current_user.superuser? || current_user.administrator?(@country.country)
      if @absence.update_attributes(params[:country_absence])
        flash[:success] = "Absence code '#{@absence.absence_code}' for #{@country.country} has been updated."
        redirect_to country_country_absences_path(@country)
      else
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
  
    def country_admin_access
      if signed_in?
        unless current_user.superuser?
          admin_check = CountryAdmin.find_by_user_id_and_country_id(current_user.id, @country.id)
          if admin_check.nil?
            flash[:notice] = "You must be a registered administrator for #{@country.country} to make changes."
            redirect_to user_path(current_user)
          end
        end
      end
    end
end
