class InsuranceSettingsController < ApplicationController
  
  before_filter :check_admin
  before_filter :signed_in_user, except: [:update, :create, :destroy]
  before_filter :illegal_action, only: [:update, :create, :destroy]
  
  def index
    @country = Country.find(params[:country_id])
    check_permitted
    @settings = @country.insurance_settings.current_list
    @recent_adds = InsuranceSetting.total_recent(@country)
    @recent_updates = InsuranceSetting.total_updated(@country)
    unset_insset_cancellation
  end
  
  def new
    @country = Country.find(params[:country_id]) 
    country_admin_access
    check_permitted
    @setting = @country.insurance_settings.new
  end
  
  def create
    @country = Country.find(params[:country_id])
    check_permitted
    if current_user.superuser? || current_user.administrator?(@country.country)
      @setting = @country.insurance_settings.new(params[:insurance_setting])
      if @setting.save
        if @setting.effective_date > Date.today
          flash[:success] = "You've set new salary milestones for the code '#{@setting.shortcode}' in #{@country.country}. It will 
            be activated by HR2.0 automatically when the date arrives. The list below shows all settings you've
            already scheduled for future activation."
          redirect_to country_insurance_future_settings_path(@country)
        elsif @setting.in_current_list == true
          flash[:success] = "New settings have been created for the '#{@setting.shortcode}' code in #{@country.country}."
          redirect_to country_insurance_settings_path(@country)
        else
          flash[:success] = "You've added an older '#{@setting.shortcode}' record in the Salary Thresholds list for 
            #{@country.country}.  You'll find it in this list which shows past, present and future settings."
          redirect_to country_insurance_history_settings_path(@country)  
        end
      else
        render 'new'
      end
    else
      flash[:notice] = "You must be a registered administrator for #{@country.country}."
      redirect_to user_path(current_user) 
    end
  end

  def edit
    @setting = InsuranceSetting.find(params[:id])
    @country = Country.find(@setting.country_id)
    country_admin_access
    set_insset_cancellation_status
  end
  
  def update
    @setting = InsuranceSetting.find(params[:id])
    @country = Country.find(@setting.country_id)
    if current_user.superuser? || current_user.administrator?(@country.country)
      if @setting.update_attributes(params[:insurance_setting])
        if insset_cancellation_status_changed?  
          if @setting.cancellation_date?
            if @setting.cancellation_date > Date.today  
              flash[:success] = "You've just cancelled the '#{@setting.shortcode}' entry - but for a date in the future.
                It will continue to appear in the Current list until the cancellation date, when HR2.0 will automatically
                re-assign it to the History list."
              redirect_to country_insurance_settings_path(@country)
            else
              flash[:success] = "You've just cancelled the '#{@setting.shortcode}' entry - the one with an effective
                date of #{@setting.effective_date}.  It will still be displayed in the History list."
              redirect_to country_insurance_history_settings_path(@country)
            end
          else
            flash[:success] = "You've just reactivated the setting for '#{@setting.shortcode}' with an effective
              date of #{@setting.effective_date} - previously it had been cancelled.  The list below shows the
              full history of Threshold Salary settings for insurance calculations in #{@country.country}, so
              you can check that everything is now correct."
            redirect_to country_insurance_history_settings_path(@country)  
          end
        else  
          if @setting.effective_date > Date.today
            flash[:success] = "The Salary Threshold listing for the '#{@setting.shortcode}' code you've just updated 
              will be activated automatically on #{@setting.effective_date}.  The list below shows all other future 
              changes already scheduled for #{@country.country}."
            redirect_to country_insurance_future_settings_path(@country)
          elsif @setting.in_current_list == true
            flash[:success] = "The '#{@setting.shortcode}' code has been updated."
            redirect_to country_insurance_settings_path(@country)
          else
            flash[:success] = "You've updated an older '#{@setting.shortcode}' record in the Salary Thresholds list for 
              #{@country.country}.  You'll find it in this list which shows past, present and future settings."
            redirect_to country_insurance_history_settings_path(@country)
          end
        end    
        
      else
        render 'edit'
      end
      
    else
      flash[:notice] = "You must be a registered administrator for #{@country.country} to make changes."
      redirect_to user_path(current_user)
    end
  end
  
  def destroy
    @setting = InsuranceSetting.find(params[:id])
    @country = Country.find(@setting.country_id)
    if current_user.superuser? || current_user.administrator?(@country.country)
      @setting.destroy
      flash[:success] = "The '#{@setting.shortcode}' line for #{@country.country} with effective date #{@setting.effective_date.strftime('%d %b %Y')} has been destroyed."
      redirect_to country_insurance_settings_path(@country)
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
    
    def check_permitted
      unless @country.insurance?
        flash[:notice] = "National Insurance is switched off for this country"
        redirect_to user_path(current_user)
      end
    end
end
