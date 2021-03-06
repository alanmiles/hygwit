class InsuranceHistoryRatesController < ApplicationController
  
  before_filter :signed_in_user
  before_filter :check_admin
  
  def index
    @country = Country.find(params[:country_id])
    unless @country.insurance?
      flash[:notice] = "National Insurance is switched off for this country"
      redirect_to user_path(current_user)
    else
      #@selection = @country.insurance_rates.where("source_employee = ?", true)
      @rates = @country.insurance_rates.history_list(true)
      @page_title = "Insurance Rate History - Employees"
      @list_type = "is the historical list of rates for employees"
      session[:group_focus] = "employee"
      session[:time_focus] = "past"
      @recent_adds = InsuranceRate.total_recent(@country)
      @recent_updates = InsuranceRate.total_updated(@country)
      @recent_add_checks = InsuranceRate.recent_add_checks(@country)
      @recent_update_checks = InsuranceRate.recent_update_checks(@country)
    end
  end
  
end
