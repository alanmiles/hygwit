class CountriesController < ApplicationController
  
  before_filter :check_admin
  before_filter :signed_in_user
  
  def index
    @countries = Country.all
  end
  
  def show
    @country = Country.find(params[:id])
  end

  def new
    @country = Country.new
    @nationalities = Nationality.all
    @currencies = Currency.all
  end
  
  def create
    @country = Country.new(params[:country])
    if @country.save
      flash[:success] = "'#{@country.country}' added"
      redirect_to @country
    else
      @nationalities = Nationality.all
      @currencies = Currency.all
      render 'new'
    end
  end

  def edit
   @country = Country.find(params[:id])
   @nationalities = Nationality.all
   @currencies = Currency.all
  end
  
  def update
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
    @country = Country.find(params[:id]).destroy
    flash[:success]= "'#{@country.country}' destroyed"
    redirect_to countries_path
  end
  
end
