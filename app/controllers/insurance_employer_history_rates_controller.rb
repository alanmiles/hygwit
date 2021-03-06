class InsuranceEmployerHistoryRatesController < ApplicationController
 
  before_filter :signed_in_user
  before_filter :check_admin
  
  def index
    @country = Country.find(params[:country_id])
    unless @country.insurance?
      flash[:notice] = "National Insurance is switched off for this country"
      redirect_to user_path(current_user)
    else
      #@selection = @country.insurance_rates.where("source_employee = ?", false)
      @rates = @country.insurance_rates.history_list(false)
      @page_title = "Insurance Rate History - Employers"
      @list_type = "is the historical list of rates for employers"
      session[:group_focus] = "employer"
      session[:time_focus] = "past" 
      @recent_adds = InsuranceRate.total_recent(@country)
      @recent_updates = InsuranceRate.total_updated(@country)
      @recent_add_checks = InsuranceRate.recent_add_checks(@country)
      @recent_update_checks = InsuranceRate.recent_update_checks(@country)
    end
  end
  
end
