class HolidaysController < ApplicationController
 
  before_filter :check_admin
  before_filter :signed_in_user, except: [:update, :create, :destroy]
  before_filter :illegal_action, only: [:update, :create, :destroy]
  
  def index
    @country = Country.find(params[:country_id])
    #country_admin_access
    #@holidays = @country.holidays
    @holidays = @country.holidays.paginate(page: params[:page], per_page: 20)
  end
  
  def new
    @country = Country.find(params[:country_id])
    country_admin_access
    @holiday = @country.holidays.new
    #@holiday.created_by = current_user.id
  end
  
  def create
    @country = Country.find(params[:country_id])
    if current_user.superuser? || current_user.administrator?(@country.country)
      @holiday = @country.holidays.new(params[:holiday])
      if @holiday.save
        flash[:success] = "Holiday starting on #{@holiday.start_date}' has been added for #{@country.country}."
        redirect_to country_holidays_path(@country)
      else
        #@holiday.created_by = current_user.id
        render 'new'
      end
    else
      flash[:notice] = "You must be a registered administrator for #{@country.country}."
      redirect_to user_path(current_user) 
    end
  end

  def edit
    @holiday = Holiday.find(params[:id])
    @country = Country.find(@holiday.country_id)
    country_admin_access
  end
  
  def update
    @holiday = Holiday.find(params[:id])
    @country = Country.find(@holiday.country_id)
    if current_user.superuser? || current_user.administrator?(@country.country)
      if @holiday.update_attributes(params[:holiday])
        flash[:success] = "Holiday starting on #{@holiday.start_date} for #{@country.country} has been updated."
        redirect_to country_holidays_path(@country)
      else
        render 'edit'
      end
    else
      flash[:notice] = "You must be a registered administrator for #{@country.country} to make changes."
      redirect_to user_path(current_user)
    end
  end
  
  def destroy
    @holiday = Holiday.find(params[:id])
    @country = Country.find(@holiday.country_id)
    if current_user.superuser? || current_user.administrator?(@country.country)
      @holiday.destroy
      flash[:success] = "Holiday starting on #{@holiday.start_date} for #{@country.country} destroyed."
      redirect_to country_holidays_path(@country)
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
