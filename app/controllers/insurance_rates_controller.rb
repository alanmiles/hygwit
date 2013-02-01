class InsuranceRatesController < ApplicationController
  
  before_filter :check_admin
  before_filter :signed_in_user, except: [:update, :create, :destroy]
  before_filter :illegal_action, only: [:update, :create, :destroy]
  
  def index
    @country = Country.find(params[:country_id])
    unless @country.insurance?
      flash[:notice] = "National Insurance is switched off for this country"
      redirect_to user_path(current_user)
    else
      #@selection = @country.insurance_rates.where("source_employee = ?", true)
      @rates = InsuranceRate.current_list(@country, true)
      @page_title = "Current Insurance Rates - Employees"
      @list_type = "are the current rates for employees"
      session[:group_focus] = "employee"
      session[:time_focus] = "current"
      session[:rate_date] = nil
    
      @recent_adds = InsuranceRate.total_recent(@country)
      @recent_updates = InsuranceRate.total_updated(@country)
      @recent_add_checks = InsuranceRate.recent_add_checks(@country)
      @recent_update_checks = InsuranceRate.recent_update_checks(@country)
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
        @rate = @country.insurance_rates.new
        unless session[:rate_date] == nil
          @rate.effective = session[:rate_date]
          @codes = @country.insurance_codes.on_active_list(@rate.effective)
          @settings = @country.insurance_settings.snapshot_list(@rate.effective)
        else
          @codes = @country.insurance_codes.on_current_list
          @settings = @country.insurance_settings.snapshot_list(Date.today)
        end
        @rate.created_by = current_user.id
        @rate.updated_by = current_user.id
        @rate.checked = true if current_user.superuser?
        @edit = false
      end
    end
  end
  
  def create
    @country = Country.find(params[:country_id])
    unless current_user.administrator?(@country.country) || current_user.superuser?
      country_admin_access
      session[rate_date] == nil
    else
      unless @country.insurance?
        flash[:notice] = "National Insurance is switched off for this country"
        redirect_to user_path(current_user)
      else
        @rate = @country.insurance_rates.new(params[:insurance_rate])
        if params[:insurance_rate][:effective] == ""
          flash.now[:error] = "You must set an effective date"
          @rate = @country.insurance_rates.new
          @codes = @country.insurance_codes.on_current_list
          @settings = @country.insurance_settings.snapshot_list(Date.today)
          @rate.created_by = current_user.id
          @rate.updated_by = current_user.id
          @rate.checked = true if current_user.superuser?
          @edit = false
          render 'new'
        else  
          if (params[:insurance_rate][:effective] != "") && (@rate.contribution == nil)
            session[:rate_date] = params[:insurance_rate][:effective]    
            @rate.created_by = current_user.id
            @rate.updated_by = current_user.id
            @rate.checked = true if current_user.superuser?
            @codes = @country.insurance_codes.on_active_list(@rate.effective)
            @settings = @country.insurance_settings.snapshot_list(@rate.effective)
            @edit = false
            flash.now[:success] = "Now continue entering the rest of the details.  (If no response on 'Create' check that 'Contribution'
						  field is filled.)"
            render 'new' 
          else 
            if @rate.save
              @country = Country.find(@rate.country_id)
              @ceiling_val = @country.insurance_settings.auto_ceiling(@rate.effective, @rate.threshold_id)
              @rate.update_attributes(ceiling_id: @ceiling_val) unless @ceiling_val.nil? 
              flash[:success] = "Insurance rates for #{@country.country} have been updated."
              if @rate.source_employee?
                if @rate.effective <= Date.today
                  if @rate.in_current_list == true
                    flash[:success] = "You've successfully added Code-Band #{@rate.code_band_identifier}
                      to the active list for EMPLOYEES in #{@country.country}."
                    redirect_to country_insurance_rates_path(@country)
                  else
                    flash[:success] = "You've added an older Code-Band - #{@rate.code_band_identifier} - to the insurance rates for 
                      EMPLOYEES in #{@country.country}.  You'll find it in this list which shows past, present and future rates."
                    redirect_to country_insurance_history_rates_path(@country)
                  end
                else
                  session[:irate] = "employee_future"
                  flash[:success] = "You've set a new Code-Band - #{@rate.code_band_identifier} - to the insurance rates for EMPLOYEES 
                    with an effective date in the future. It will be activated by HR2.0 automatically when the date arrives. 
                    The list here shows all employee rates you've already scheduled for future activation."
                  redirect_to country_insurance_future_rates_path(@country)
                end
              else
                if @rate.effective <= Date.today
                  if @rate.in_current_list == true
                    flash[:success] = "You've successfully added the new Code-Band - #{@rate.code_band_identifier} - to the 
                      active list of national insurance rates for EMPLOYERS in #{@country.country}."
                    redirect_to country_insurance_employer_rates_path(@country)
                  else
                    flash[:success] = "You've added an older Code-Band - #{@rate.code_band_identifier} - to the insurance rates for 
                      EMPLOYERS in #{@country.country}.  You'll find it in this list which shows past, present and future rates."
                      redirect_to country_insurance_employer_history_rates_path(@country)
                  end
                else
                  flash[:success] = "You've set a new Code-Band - #{@rate.code_band_identifier} - to the insurance rates for employers
                    with an effective date in the future. It will be activated by HR2.0 automatically when the date arrives. 
                    The list here shows all employer rates you've already scheduled for future activation."
                  redirect_to country_insurance_employer_future_rates_path(@country)
                end
              end
              session[:rate_date] == nil
            else
              @rate.created_by = current_user.id
              @rate.updated_by = current_user.id
              @rate.checked = true if current_user.superuser?
              #@codes = @country.insurance_codes.on_current_list
              @settings = @country.insurance_settings.current_and_future_list
              @edit = false
              unless session[:rate_date] == nil
                @rate.effective = session[:rate_date]
                @codes = @country.insurance_codes.on_active_list(@rate.effective)
              else
                @codes = @country.insurance_codes.on_current_list
              end
              render 'new'
            end
          end
        end
      end
    end
  end

  def edit
    @rate = InsuranceRate.find(params[:id])
    @country = Country.find(@rate.country_id)
    unless current_user.administrator?(@country.country) || current_user.superuser?
      country_admin_access
    else
      unless @country.insurance?
        flash[:notice] = "National Insurance is switched off for this country"
        redirect_to user_path(current_user)
      else
        @rate.updated_by = current_user.id unless current_user.superuser?  #superuser check doesn't change inputter reference
        #@rate.checked = true if current_user.superuser?
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
          if @rate.in_current_list
            if @rate.source_employee == true
              redirect_to country_insurance_rates_path(@country)
            else
              redirect_to country_insurance_employer_rates_path(@country)
            end
          elsif @rate.in_future_list
            if @rate.source_employee == true
              redirect_to country_insurance_future_rates_path(@country)
            else
              redirect_to country_insurance_employer_future_rates_path(@country)
            end
          else
            if @rate.source_employee == true
              redirect_to country_insurance_history_rates_path(@country)
            else
              redirect_to country_insurance_employer_history_rates_path(@country)
            end
          end
        else
          @rate.updated_by = current_user.id unless current_user.superuser?
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
          if session[:time_focus] == "current"
            redirect_to country_insurance_rates_path(@country)
          elsif session[:time_focus] == "future"
            redirect_to country_insurance_future_rates_path(@country)
          else
            redirect_to country_insurance_history_rates_path(@country)
          end
        else
          if session[:time_focus] == "current"
            redirect_to country_insurance_employer_rates_path(@country)
          elsif session[:time_focus] == "future"
            redirect_to country_insurance_employer_future_rates_path(@country)
          else
            redirect_to country_insurance_employer_history_rates_path(@country)
          end
        end
      end
    end
  end
  
end
