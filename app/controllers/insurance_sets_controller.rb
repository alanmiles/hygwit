class InsuranceSetsController < ApplicationController
  
  before_filter :signed_in_user, except: [:update, :create, :destroy]
  before_filter :illegal_action, only: [:update, :create, :destroy]
  before_filter :check_admin
  
  def index
    #displays all the records that have been created on the effective date, allowing values to be updated - html or js
    @country = Country.find(params[:country_id])
    unless current_user.administrator?(@country.country) || current_user.superuser?
      country_admin_access
    else
      unless @country.insurance?
        flash[:notice] = "National Insurance is switched off for this country"
        redirect_to user_path(current_user)
      else
        session[:group_focus] = "employee"
        if session[:insurance_date] == nil
          @apply_date = Date.today
        else
          @apply_date = session[:insurance_date] 
        end
        @rates = InsuranceRate.active_list(@country, true, @apply_date)
        @page_title = "New National Insurance Rates Set - Employees"
        @list_type = "are the new rates for employees"
        @focus = "employee"
      end
    end
  end

  def new
    @country = Country.find(params[:country_id]) 
    unless current_user.superuser? || current_user.administrator?(@country.country)
      country_admin_access
    else
      unless @country.insurance?
        flash[:notice] = "National Insurance is switched off for this country"
        redirect_to user_path(current_user)
      else
        #form a single new insurance rate record with lowest code, lowest threshold - but show only the date.  Rest of the form is hidden.
        #Fields that must be filled are country_id, insurance_code_id, contribution, created_by, threshold_id, effective
        if @country.insurance_codes.count == 0 || @country.insurance_settings.count == 0
          flash[:error] = "You must have at least one insurance code and one previous salary threshold 
            setting to use the 'settings update' button"
          redirect_to insurance_menu_country_path(@country)
        else
          @rate = @country.insurance_rates.new
          @rate.insurance_code_id = @country.insurance_codes.first_on_current_list.id
          @rate.contribution = 3.33
		      @rate.threshold_id = @country.insurance_settings.first_on_current_list.id
		      @rate.updated_by = current_user.id
		      @rate.created_by = current_user.id
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
        @eff_date = params[:insurance_rate][:effective]
        if @eff_date.nil? || @eff_date.empty?
          flash.now[:error] = "You must set an effective date"
          @rate = @country.insurance_rates.new
          @rate.insurance_code_id = @country.insurance_codes.first_on_current_list.id
          @rate.contribution = 3.33
		      @rate.threshold_id = @country.insurance_settings.first_on_current_list.id
		      @rate.updated_by = current_user.id
		      @rate.created_by = current_user.id
          render 'new'
        else
          session[:insurance_date] = @eff_date
          @seq = 0
          @sources = [true, false]
          @rebates = [false, true]
          #collect codes at effective date
          @codes = @country.insurance_codes.on_active_list(@eff_date)
          @codes.each do |code|
            #collect settings at effective date
            @settings = @country.insurance_settings.snapshot_list(@eff_date)
            @settings.each do |setting|
              @ceiling = @country.insurance_settings.auto_ceiling(@eff_date, setting.id)
              @sources.each do |source|
                @rebates.each do |rebate|
                #find the equivalent rate then the value in @old_rates
                  if InsuranceRate.previous_contribution(@country, code.insurance_code, setting.shortcode, source, rebate, @eff_date) == nil
                    @previous = nil
                  else
                    @previous = InsuranceRate.previous_contribution(@country, code.insurance_code, setting.shortcode, source, rebate, @eff_date)
                    @old_cont = @previous.contribution
                    @old_percent = @previous.percent
                  end
              
                  #don't overwrite any existing rates with the same date
                  unless @country.insurance_rates.duplicate_exists?(code.id, setting.id, source, rebate, @eff_date) 
                    unless @previous == nil
                      @country.insurance_rates.create(insurance_code_id: code.id, source_employee: source, threshold_id: setting.id,
        					      ceiling_id: @ceiling, contribution: @old_cont, percent: @old_percent, created_by: current_user.id, 
        					      updated_by: current_user.id, rebate: rebate, effective: @eff_date)
        			      end
        			    end
                end
              end
            end
          end
      
          if InsuranceRate.active_list(@country, true, @eff_date).count == 0
            flash[:notice] = "No new rates can be created for #{@eff_date.to_date.strftime("%d %b %Y")} - probably 
              because no Insurance thresholds have been set for the date.  Please try again with a different date."
            redirect_to new_country_insurance_set_path(@country)
          else
            flash[:success] = "This is the National Insurance table for #{@eff_date.to_date.strftime("%d %b %Y")}.  
              Now complete the table by updating the contribution rates, if necessary, for both employees and employers"
            redirect_to country_insurance_sets_path(@country)
          end 
        end
      end
    end
  end
  
  def edit
    @rate = InsuranceRate.find(params[:id])
    @rate.checked = true if current_user.superuser?
    @country = Country.find(@rate.country_id)
    unless current_user.administrator?(@country.country) || current_user.superuser?
      country_admin_access
    else
      unless @country.insurance?
        flash[:notice] = "National Insurance is switched off for this country"
        redirect_to user_path(current_user)
      end
    end
  end
  
  def update
    @rate = InsuranceRate.find(params[:id])
    @country = Country.find(@rate.country_id)
    unless current_user.administrator?(@country.country) || current_user.superuser?
      country_admin_access
    else
      unless @country.insurance?
        flash[:notice] = "National Insurance is switched off for this country"
        redirect_to user_path(current_user)
      else
        if @rate.update_attributes(params[:insurance_rate])
          @rate.update_attributes(checked: false) unless current_user.superuser?
          flash[:success] = "Code-Band #{@rate.code_band_identifier} has been updated."
          if @rate.source_employee?  
            redirect_to country_insurance_sets_path(@country)
          else
          
            redirect_to country_insurance_employer_sets_path(@country)
          end
        else
          render 'edit'
        end
      end
    end      
  end
  
  def destroy
    @rate = InsuranceRate.find(params[:id])
    @country = Country.find(@rate.country_id)
    unless current_user.administrator?(@country.country) || current_user.superuser?
      country_admin_access
    else
      unless @country.insurance?
        flash[:notice] = "National Insurance is switched off for this country"
        redirect_to user_path(current_user)
      else
        @rate.destroy
        flash[:success] = "Code-Band #{@rate.code_band_identifier} has been deleted."
        if session[:group_focus] == "employee"
          redirect_to country_insurance_sets_path(@country)
        else
          redirect_to country_insurance_employer_sets_path(@country) 
        end
      end
    end
  end
  
end
