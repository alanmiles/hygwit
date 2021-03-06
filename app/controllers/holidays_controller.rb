class HolidaysController < ApplicationController
 
  before_filter :signed_in_user, except: [:update, :create, :destroy]
  before_filter :illegal_action, only: [:update, :create, :destroy]
  before_filter :check_admin
  
  def index
    @country = Country.find(params[:country_id])
    @holidays = @country.holidays.paginate(page: params[:page], per_page: 20)
    @recent_adds = Holiday.total_recent(@country)
    @recent_updates = Holiday.total_updated(@country)
    @recent_add_checks = Holiday.recent_add_checks(@country)
    @recent_update_checks = Holiday.recent_update_checks(@country)
  end
  
  def new
    @country = Country.find(params[:country_id])
    country_admin_access
    @holiday = @country.holidays.new
    @holiday.created_by = current_user.id
    @holiday.updated_by = current_user.id
    @holiday.checked = true if current_user.superuser?
  end
  
  def create
    @country = Country.find(params[:country_id])
    if current_user.superuser? || current_user.administrator?(@country.country)
      @holiday = @country.holidays.new(params[:holiday])
      if @holiday.save
        flash[:success] = "Holiday starting on #{@holiday.start_date} has been added for #{@country.country}."
        redirect_to country_holidays_path(@country)
      else
        @holiday.created_by = current_user.id
        @holiday.updated_by = current_user.id
        @holiday.checked = true if current_user.superuser?
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
    @holiday.updated_by = current_user.id unless current_user.superuser?  #superuser check doesn't change inputter reference
  end
  
  def update
    @holiday = Holiday.find(params[:id])
    @country = Country.find(@holiday.country_id)
    if current_user.superuser? || current_user.administrator?(@country.country)
      if @holiday.update_attributes(params[:holiday])
        @holiday.update_attributes(checked: false) unless current_user.superuser?
        flash[:success] = "Holiday starting on #{@holiday.start_date} for #{@country.country} has been updated."
        redirect_to country_holidays_path(@country)
      else
        @holiday.updated_by = current_user.id unless current_user.superuser?
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
  
end
