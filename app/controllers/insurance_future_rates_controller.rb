class InsuranceFutureRatesController < ApplicationController
  
  before_filter :check_admin
  before_filter :signed_in_user
  
  def index
    @country = Country.find(params[:country_id])
    check_permitted
    @rates = @country.insurance_rates.future_list
    @recent_adds = InsuranceSetting.total_recent(@country)
    @recent_updates = InsuranceSetting.total_updated(@country)
    @recent_add_checks = InsuranceSetting.recent_add_checks(@country)
    @recent_update_checks = InsuranceSetting.recent_update_checks(@country)
  end
  
  private
  
    def check_permitted
      unless @country.insurance?
        flash[:notice] = "National Insurance is switched off for this country"
        redirect_to user_path(current_user)
      end
    end
end