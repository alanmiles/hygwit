class CountryAdminsController < ApplicationController

  before_filter :check_superuser
  #before_filter :signed_in_user, except: [:update, :destroy]
  #before_filter :illegal_action, only: [:update, :destroy]
  
  def new
    @country_admin = CountryAdmin.new
    @countries = Country.all
    @admins = User.where("admin =?", true) 
  end

  def create
    @country_admin = CountryAdmin.new(params[:country_admin])
    if @country_admin.save
      flash[:success] = "#{@country_admin.user.name} is now an administrator for #{@country_admin.country.country}"
      redirect_to country_admins_path
    else
      @countries = Country.all
      @admins = User.where("admin =?", true) 
      render 'new'
    end
  end
  
  def index
    @country_admins = CountryAdmin.joins(:country, :user).order("countries.country, users.name")
  end

  def edit
    @country_admin = CountryAdmin.find(params[:id])
    @countries = Country.all
    @admins = User.where("admin =?", true) 
  end
  
  def update
    @country_admin = CountryAdmin.find(params[:id])
    if @country_admin.update_attributes(params[:country_admin])
      flash[:success] = "#{@country_admin.user.name} is now an administrator for #{@country_admin.country.country}"
      redirect_to country_admins_path
    else
      @countries = Country.all
      @admins = User.where("admin =?", true) 
      render "edit"
    end
  end
  
  def destroy
    @country_admin = CountryAdmin.find(params[:id]).destroy
    flash[:success]= "#{@country_admin.user.name} is no longer an administrator for #{@country_admin.country.country}"
    redirect_to country_admins_path
  end
end
