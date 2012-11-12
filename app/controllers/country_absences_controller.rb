class CountryAbsencesController < ApplicationController
  
  before_filter :check_admin
  before_filter :signed_in_user, except: [:update, :destroy]
  before_filter :illegal_action, only: [:update, :destroy]
  
  def index
    @country = Country.find(params[:country_id])
    @absences = @country.country_absences
  end
  
  def new
    @country = Country.find(params[:country_id])
    @absence = @country.country_absences.new
  end
  
  def create
    @country = Country.find(params[:country_id])
    @absence = @country.country_absences.new(params[:country_absence])
    if @absence.save
      flash[:success] = "Absence code '#{@absence.absence_code}' has been added for #{@country.country}."
      redirect_to country_country_absences_path(@country)
    else
      render 'new'
    end
  end

  def edit
    @absence = CountryAbsence.find(params[:id])
    @country = Country.find(@absence.country_id)
  end
  
  def update
    @absence = CountryAbsence.find(params[:id])
    @country = Country.find(@absence.country_id)
    if @absence.update_attributes(params[:country_absence])
      flash[:success] = "Absence code '#{@absence.absence_code}' for #{@country.country} has been updated."
      redirect_to country_country_absences_path(@country)
    else
      render 'edit'
    end
  end
  
  def destroy
    @absence = CountryAbsence.find(params[:id])
    @country = Country.find(@absence.country_id)
    @absence.destroy
    flash[:success] = "Absence code #{@absence.absence_code} for #{@country.country} destroyed."
    redirect_to country_country_absences_path(@country)
  end
end
