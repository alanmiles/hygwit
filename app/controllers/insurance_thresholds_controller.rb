class InsuranceThresholdsController < ApplicationController
  
  before_filter :signed_in_user, except: [:update, :create, :destroy]
  before_filter :illegal_action, only: [:update, :create, :destroy]
  before_filter :check_admin
  
  def index
    @country = Country.find(params[:country_id])
    unless current_user.administrator?(@country.country) || current_user.superuser?
      country_admin_access
    else
      unless @country.insurance?
        flash[:notice] = "National Insurance is switched off for this country"
        redirect_to user_path(current_user)
      else
        if session[:insurance_date] == nil
          @apply_date = Date.today
        else
          @apply_date = session[:insurance_date] 
        end
        @settings = @country.insurance_settings.where("effective_date =?", @apply_date).order("monthly_milestone")
      end
    end
  end
  
  def new
    @country = Country.find(params[:country_id])
    unless current_user.administrator?(@country.country) || current_user.superuser?
      country_admin_access
    else
      unless @country.insurance?
        flash[:notice] = "National Insurance is switched off for this country"
        redirect_to user_path(current_user)
      else
        @old_setting = @country.insurance_settings.first_on_current_list
        if @old_setting.nil?
          flash[:error] = "You must have at least one previous salary threshold setting to use the 'settings update' button"
          redirect_to country_insurance_settings_path(@country)
        else
          @setting = @country.insurance_settings.new
          @setting.shortcode = @old_setting.shortcode
          @setting.name = @old_setting.name
		      @setting.weekly_milestone = @old_setting.weekly_milestone
		      @setting.monthly_milestone = @old_setting.monthly_milestone
		      @setting.annual_milestone = @old_setting.annual_milestone
		      @setting.updated_by = current_user.id
		      @setting.created_by = current_user.id
		      session[:insurance_date] = nil
		    end
		  end
		end
  end
  
  def create
    @country = Country.find(params[:country_id])
    unless current_user.administrator?(@country.country) || current_user.superuser?
      country_admin_access
    else
      unless @country.insurance?
        flash[:notice] = "National Insurance is switched off for this country"
        redirect_to user_path(current_user)
      else
        @eff_date = params[:insurance_setting][:effective_date]
        if @eff_date.nil? || @eff_date.empty?
          flash.now[:error] = "You must set an effective date"
          @old_setting = @country.insurance_settings.first_on_current_list
          @setting = @country.insurance_settings.new
          @setting.shortcode = @old_setting.shortcode
          @setting.name = @old_setting.name
		      @setting.weekly_milestone = @old_setting.weekly_milestone
		      @setting.monthly_milestone = @old_setting.monthly_milestone
		      @setting.annual_milestone = @old_setting.annual_milestone
		      @setting.updated_by = current_user.id
		      @setting.created_by = current_user.id
          render 'new'
        else
          session[:insurance_date] = @eff_date
          #collect current settings
          @settings = @country.insurance_settings.current_list
          @settings.each do |setting|
            #don't overwrite any existing settings with the same date
            unless @country.insurance_settings.duplicate_exists?(setting.shortcode, @eff_date)
              @country.insurance_settings.create(shortcode: setting.shortcode, name: setting.name, 
                weekly_milestone: setting.weekly_milestone, monthly_milestone: setting.monthly_milestone, 
                annual_milestone: setting.annual_milestone, effective_date: @eff_date,
        		    created_by: current_user.id, updated_by: current_user.id)
            end
          end   
        
          flash[:success] = "A new set of National Insurance salary thresholds has been successfully created -  
             starting #{@eff_date.to_date.strftime("%d %b %Y")}. But you now need to update each of the threshold settings to
             their new values."
          redirect_to country_insurance_thresholds_path(@country)
        end
      end         
    end
  end

  def edit
    @setting = InsuranceSetting.find(params[:id])
    @country = Country.find(@setting.country_id)
    unless current_user.administrator?(@country.country) || current_user.superuser?
      country_admin_access
    else
      unless @country.insurance?
        flash[:notice] = "National Insurance is switched off for this country"
        redirect_to user_path(current_user)
      else
        #set_insset_cancellation_status
        @setting.updated_by = current_user.id unless current_user.superuser?  #superuser check doesn't change inputter reference
      end
    end
  end
  
  def update
    @setting = InsuranceSetting.find(params[:id])
    @country = Country.find(@setting.country_id)
    unless current_user.administrator?(@country.country) || current_user.superuser?
      country_admin_access
    else
      unless @country.insurance?
        flash[:notice] = "National Insurance is switched off for this country"
        redirect_to user_path(current_user)
      else
        if @setting.update_attributes(params[:insurance_setting])
          @setting.update_attributes(checked: false) unless current_user.superuser?
          flash[:success] = "The new settings for '#{@setting.name}' have been updated." 
          redirect_to country_insurance_thresholds_path(@country)    
        else
          @setting.updated_by = current_user.id unless current_user.superuser?
          render 'edit'
        end
      end
    end
  end
  
  def destroy
    @setting = InsuranceSetting.find(params[:id])
    @country = Country.find(@setting.country_id)
    unless current_user.administrator?(@country.country) || current_user.superuser?
      country_admin_access
    else
      unless @country.insurance?
        flash[:notice] = "National Insurance is switched off for this country"
        redirect_to user_path(current_user)
      else
        @setting.destroy
        flash[:success] = "The new threshold settings for '#{@setting.name}' have been deleted."
        redirect_to country_insurance_thresholds_path(@country)
      end
    end
  end
  
end
