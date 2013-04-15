class InsuranceSettingsController < ApplicationController
  
  before_filter :signed_in_user, except: [:update, :create, :destroy]
  before_filter :illegal_action, only: [:update, :create, :destroy]
  before_filter :check_admin
  
  def index
    @country = Country.find(params[:country_id])
    unless @country.insurance?
      flash[:notice] = "National Insurance is switched off for this country"
      redirect_to user_path(current_user)
    else
      @settings = @country.insurance_settings.current_list
      session[:time_focus] = "current"
      @recent_adds = InsuranceSetting.total_recent(@country)
      @recent_updates = InsuranceSetting.total_updated(@country)
      @recent_add_checks = InsuranceSetting.recent_add_checks(@country)
      @recent_update_checks = InsuranceSetting.recent_update_checks(@country)
      unset_insset_cancellation
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
        @setting = @country.insurance_settings.new
        @setting.created_by = current_user.id
        @setting.updated_by = current_user.id
        @setting.checked = true if current_user.superuser?
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
        @setting = @country.insurance_settings.new(params[:insurance_setting])
        if @setting.save
          if @setting.effective_date > Date.today
            flash[:success] = "You've set new salary thresholds for the code '#{@setting.shortcode}' 
              from #{@setting.effective_date.to_date.strftime("%d %b %Y")}.  They'll be activated by HR2.0 automatically when the date 
              arrives. The list below shows all threshold settings you've already scheduled for future activation.  
              When you've finished adding settings, go to National Insurance rates and reset the rates from the same effective date."
            redirect_to country_insurance_future_settings_path(@country)
          elsif @setting.in_current_list == true
            flash[:success] = "New salary threshold settings have been created for the '#{@setting.shortcode}' code 
              from #{@setting.effective_date.to_date.strftime("%d %b %Y")}.  When you've finished adding settings, 
              go to National Insurance rates and reset the rates from the same effective date."
            redirect_to country_insurance_settings_path(@country)
          else
            flash[:success] = "You've added an older '#{@setting.shortcode}' record in the Salary Thresholds list from 
              #{@setting.effective_date.to_date.strftime("%d %b %Y")}.  You'll find it in this list which shows past, present and 
              future settings.  When you've finished adding settings, go to National Insurance rates and set rates 
              from the same effective date."
            redirect_to country_insurance_history_settings_path(@country)  
          end
        else
          @setting.created_by = current_user.id
          @setting.updated_by = current_user.id
          @setting.checked = true if current_user.superuser?
          render 'new'
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
        set_insset_cancellation_status
        @setting.updated_by = current_user.id unless current_user.superuser?  #superuser check doesn't change inputter reference
        if @setting.checked?
          if @setting.cancellation_date?
            @header = "Restore Salary Threshold Code"
          else
            @header = "Cancel Salary Threshold Code"
          end
        else
          @header = "Edit Salary Thresholds"
        end
      end
    end
  end
  
  def update
    @setting = InsuranceSetting.find(params[:id])
    @old_cancellation = @setting.cancellation_date
    @country = Country.find(@setting.country_id)
    unless current_user.administrator?(@country.country) || current_user.superuser?
      country_admin_access
    else
      unless @country.insurance?
        flash[:notice] = "National Insurance is switched off for this country"
        redirect_to user_path(current_user)
      else
        if @setting.update_attributes(params[:insurance_setting]) 
          if insset_cancellation_status_changed? || @old_cancellation != @setting.cancellation_date 
            @setting.update_attributes(cancellation_change: true) unless current_user.superuser?
            InsuranceSetting.cancel_status_all(@setting.id)
            if @setting.cancellation_date?
              if @setting.cancellation_date > Date.today  
                flash[:success] = "You've just cancelled the '#{@setting.shortcode}' entry - but for a date in the future.
                  It will continue to appear in the Current list until the cancellation date, when HR2.0 will automatically
                  re-assign it to the History list. Don't forget to reset National Insurance Rates from the same cancellation date
                  when you've finished editing."
                redirect_to country_insurance_settings_path(@country)
              else   
                flash[:success] = "You've just cancelled the '#{@setting.shortcode}' category - with effect 
                  from #{@setting.cancellation_date.to_date.strftime('%d %b %Y')}.  It will still be displayed in the History list.
                  Don't forget to reset National Insurance Rates from the same cancellation date when you've finished editing."
                redirect_to country_insurance_history_settings_path(@country)
              end
            else
              flash[:success] = "You've just re-activated the setting for '#{@setting.shortcode}' with an effective
                date of #{@setting.effective_date.to_date.strftime('%d %b %Y')} - previously it had been cancelled.  
                The list below shows the full history of Threshold Salary settings for insurance calculations in 
                #{@country.country}, so you can check that everything is now correct. Don't forget to reset 
                National Insurance Rates from the same cancellation date when you've finished editing."
              redirect_to country_insurance_history_settings_path(@country)  
            end
            
          else
         
            @setting.update_attributes(checked: false) unless current_user.superuser? 
            if @setting.effective_date > Date.today
              flash[:success] = "The Salary Threshold listing for the '#{@setting.shortcode}' code you've just updated 
                will be activated automatically on #{@setting.effective_date.to_date.strftime('%d %b %Y')}.  The list 
                below shows all other future changes already scheduled for #{@country.country}. Make sure you reset 
                National Insurance rates from the same effective date."
              redirect_to country_insurance_future_settings_path(@country)
            elsif @setting.in_current_list == true
              flash[:success] = "The '#{@setting.shortcode}' code has been updated.  After making the change, check that
                your National Insurance rates are still up-to-date."
              redirect_to country_insurance_settings_path(@country)
            else
              flash[:success] = "You've updated an older '#{@setting.shortcode}' record in the Salary Thresholds list for 
                #{@country.country}.  You'll find it in this list which shows past, present and future settings.  When you've
                finished editing, make sure there's a set of National Insurance Rates from the same effective date."
              redirect_to country_insurance_history_settings_path(@country)
            end
            unset_insset_cancellation
          end      
        else
          @setting.updated_by = current_user.id unless current_user.superuser?
          @header = "Edit Salary Thresholds"
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
        flash[:success] = "The '#{@setting.shortcode}' setting with an effective 
           date of #{@setting.effective_date.strftime('%d %b %Y')} has been removed.
           Make sure your National Insurance Rates listing has also been updated."
        if session[:time_focus] == "future"
          redirect_to country_insurance_future_settings_path(@country)
        elsif session[:time_focus] == "current"
          redirect_to country_insurance_settings_path(@country)
        else
          redirect_to country_insurance_history_settings_path(@country)
        end
      end
    end
  end
  
end
