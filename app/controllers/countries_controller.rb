class CountriesController < ApplicationController
  
  before_filter :check_admin
  before_filter :signed_in_user, except: [:update, :destroy]
  before_filter :illegal_action, only: [:update, :destroy]
  
  def index
    @countries = Country.all
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
      render 'new'
    end
  end

  def edit
   @country = Country.find(params[:id])
   @nationalities = Nationality.all
   @currencies = Currency.all
  end
  
  def update
    params[:country].parse_time_select! :nightwork_start
    params[:country].parse_time_select! :nightwork_end
    @country= Country.find(params[:id])
    if @country.update_attributes(params[:country])
      flash[:success] = "'#{@country.country}' updated"
      redirect_to @country
    else
      @nationalities = Nationality.all
      @currencies = Currency.all
      render "edit"
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
  
end
