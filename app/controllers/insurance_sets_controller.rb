class InsuranceSetsController < ApplicationController
  
  #only available to country admins and superusers
  
  def index
    #displays all the records that have been created on the effective date, allowing values to be updated - html or js
    @country = Country.find(params[:country_id])
    ##check_permitted
    session[:group_focus] = "employee"
    #@selection = @country.insurance_rates.where("source_employee = ? and effective = ?", true, session[:insurance_date])
    if session[:insurance_date] == nil
      @apply_date = Date.today
    else
      @apply_date = session[:insurance_date] 
    end
    @rates = @country.insurance_rates.where("source_employee =? and effective =?", true, @apply_date)
    @page_title = "New National Insurance Rates Set - Employees"
    @list_type = "are the new rates for employees"
    @focus = "employee"
    ##@status = "current"
  end

  def new
    @country = Country.find(params[:country_id]) 
    #form a single new insurance rate record with lowest code, lowest threshold - but show only the date.  Rest of the form is hidden.
    #Fields that must be filled are country_id, insurance_code_id, contribution, created_by, threshold_id, effective
    @rate = @country.insurance_rates.new
    @rate.insurance_code_id = @country.insurance_codes.first_on_current_list.id
    @rate.contribution = 3.33
		@rate.threshold_id = @country.insurance_settings.first_on_current_list.id
		@rate.updated_by = current_user.id
		@rate.created_by = current_user.id
		session[:insurance_date] = nil
  end
  
  def create
    @country = Country.find(params[:country_id])
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
      #collect codes at effective date
      @codes = @country.insurance_codes.on_active_list(@eff_date)
      @codes.each do |code|
        #collect settings at effective date
        @settings = @country.insurance_settings.snapshot_list(@eff_date)
        @settings.each do |setting|
          @ceiling = @country.insurance_settings.auto_ceiling(@eff_date, setting.id)
          @sources.each do |source|
            #don't overwrite any existing rates with the same date
            unless @country.insurance_rates.duplicate_exists?(code.id, setting.id, source, false, @eff_date) 
              @country.insurance_rates.create(insurance_code_id: code.id, source_employee: source, threshold_id: setting.id,
        					ceiling_id: @ceiling, contribution: 3.33, created_by: current_user.id, updated_by: current_user.id,
        					effective: @eff_date)
            end
          end
        end
      end
      #add rebates in current list
      @selection = @country.insurance_rates
      if InsuranceRate.has_rebates?(@country, @selection, Date.today)
        @rbts = InsuranceRate.list_rebates(@country, @selection, Date.today)    
        @rbts.each do |rbt|
          #don't overwrite existing rebates with the same date
          unless @country.insurance_rates.duplicate_exists?(rbt.insurance_code_id, 
                   rbt.threshold_id, rbt.source_employee, true, @eff_date)
            @country.insurance_rates.create(insurance_code_id: rbt.insurance_code_id, source_employee: rbt.source_employee, 
                  threshold_id: rbt.threshold_id, ceiling_id: rbt.ceiling_id, contribution: 1.33, percent: rbt.percent, 
                  created_by: current_user.id, updated_by: current_user.id, effective: @eff_date, rebate: true)      
          end
        end 
      end
      
      flash[:success] = "These is the National Insurance table for #{@eff_date.to_date.strftime("%d %b %Y")}.  
         Now complete the table by updating the contribution rates, for both employees and employers"
      redirect_to country_insurance_sets_path(@country)
       
    end
  end
  
  def edit
    @rate = InsuranceRate.find(params[:id])
    @rate.checked = true if current_user.superuser?
    @country = Country.find(@rate.country_id)
    unless current_user.superuser? || current_user.administrator?(@country.country)
      country_admin_access 
    end
  end
  
  def update
    @rate = InsuranceRate.find(params[:id])
    @country = Country.find(@rate.country_id)
    if current_user.superuser? || current_user.administrator?(@country.country)
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
    else 
      flash[:notice] = "You must be a registered administrator for #{@country.country} to make changes."
      redirect_to user_path(current_user)
    end      
  end
  
  def destroy
    @rate = InsuranceRate.find(params[:id])
    @country = Country.find(@rate.country_id)
    if current_user.superuser? || current_user.administrator?(@country.country)
      @rate.destroy
      flash[:success] = "Code-Band #{@rate.code_band_identifier} has been deleted."
      if session[:group_focus] == "employee"
        redirect_to country_insurance_sets_path(@country)
      else
        redirect_to country_insurance_employer_sets_path(@country) 
      end
    else
      flash[:notice] = "You must be a registered administrator for #{@country.country} to make changes."
      redirect_to user_path(current_user)
    end
  end
  
end
