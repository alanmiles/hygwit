class InsuranceFutureRatesController < ApplicationController
  
  before_filter :check_admin
  before_filter :signed_in_user
  
  def index
    @country = Country.find(params[:country_id])
    check_permitted
    #@selection = @country.insurance_rates.where("source_employee = ?", true)
    @rates = @country.insurance_rates.future_list(true)
    @page_title = "Future Insurance Rates - Employees"
    @list_type = "are planned future rates for employees"
    session[:group_focus] = "employee"
    session[:time_focus] = "future"
    @recent_adds = InsuranceRate.total_recent(@country)
    @recent_updates = InsuranceRate.total_updated(@country)
    @recent_add_checks = InsuranceRate.recent_add_checks(@country)
    @recent_update_checks = InsuranceRate.recent_update_checks(@country)
  end
  
  private
  
    def check_permitted
      unless @country.insurance?
        flash[:notice] = "National Insurance is switched off for this country"
        redirect_to user_path(current_user)
      end
    end
end
