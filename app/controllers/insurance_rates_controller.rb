class InsuranceRatesController < ApplicationController
  
  before_filter :check_admin
  before_filter :signed_in_user, except: [:update, :create, :destroy]
  before_filter :illegal_action, only: [:update, :create, :destroy]
  
  def index
    @country = Country.find(params[:country_id])
    check_permitted
    @rates = InsuranceRate.current_list(@country)
    @recent_adds = InsuranceCode.total_recent(@country)
    @recent_updates = InsuranceCode.total_updated(@country)
    @recent_add_checks = InsuranceCode.recent_add_checks(@country)
    @recent_update_checks = InsuranceCode.recent_update_checks(@country)
  end
  
  def new
    @country = Country.find(params[:country_id]) 
    country_admin_access
    check_permitted
    @rate = @country.insurance_rates.new
    @rate.created_by = current_user.id
    @rate.updated_by = current_user.id
    @rate.checked = true if current_user.superuser?
    @codes = @country.insurance_codes.on_current_list
    @settings = @country.insurance_settings.current_and_future_list
    #@edit = false
  end
  
  def create
    @country = Country.find(params[:country_id])
    check_permitted
    if current_user.superuser? || current_user.administrator?(@country.country)
      @rate = @country.insurance_rates.new(params[:insurance_rate])
      if @rate.save
        flash[:success] = "Insurance rates for #{@country.country} have been updated."
        if @rate.source_employee?
          if @rate.effective <= Date.today
            redirect_to country_insurance_rates_path(@country)
          else
            redirect_to country_insurance_future_rates_path(@country)
          end
        else
        
        end
      else
        @rate.created_by = current_user.id
        @rate.updated_by = current_user.id
        @rate.checked = true if current_user.superuser?
        @codes = @country.insurance_codes.on_current_list
        @settings = @country.insurance_settings.current_and_future_list
        #@edit = false
        render 'new'
      end
    else
      flash[:notice] = "You must be a registered administrator for #{@country.country}."
      redirect_to user_path(current_user) 
    end
  end

  def edit
    @rate = InsuranceRate.find(params[:id])
    @country = Country.find(@rate.country_id)
    check_permitted
    country_admin_access
    @rate.updated_by = current_user.id unless current_user.superuser?  #superuser check doesn't change inputter reference
    @codes = @country.insurance_codes.on_current_list
    @settings = @country.insurance_settings.current_and_future_list
    #@edit = true
  end
  
  def update
    @rate = InsuranceRate.find(params[:id])
    @country = Country.find(@rate.country_id)
    if current_user.superuser? || current_user.administrator?(@country.country)
      unless @country.insurance?
        flash[:notice] = "National Insurance is switched off for this country"
        redirect_to user_path(current_user)
      else
        if @rate.update_attributes(params[:insurance_rate])
          @rate.update_attributes(checked: false) unless current_user.superuser?
          flash[:success] = "Insurance rates for #{@country.country} have been updated."
          redirect_to country_insurance_rates_path(@country)
        else
          #@edit = true
          @rate.updated_by = current_user.id unless current_user.superuser?
          @codes = @country.insurance_codes.on_current_list
          @settings = @country.insurance_settings.current_and_future_list 
          render 'edit'
        end
      end
    else 
      flash[:notice] = "You must be a registered administrator for #{@country.country} to make changes."
      redirect_to user_path(current_user)
    end      
  end
  
  def destroy
    @rate = InsuranceRate.find(params[:id])
    @country = Country.find(@rate.country_id)
    if current_user.superuser? || current_user.administrator?(@country.country)
      unless @country.insurance?
        flash[:notice] = "National Insurance is switched off for this country"
        redirect_to user_path(current_user)
      else  
        @rate.destroy
        flash[:success] = "An insurance rate for #{@country.country} has been destroyed."
        redirect_to country_insurance_rates_path(@country)
      end
    else
      flash[:notice] = "You must be a registered administrator for #{@country.country} to make changes."
      redirect_to user_path(current_user)
    end
  end
  
  private
    
    def check_permitted
      unless @country.insurance?
        flash[:notice] = "National Insurance is switched off for this country"
        redirect_to user_path(current_user)
      end
    end
end
