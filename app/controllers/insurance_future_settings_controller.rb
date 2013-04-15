class InsuranceFutureSettingsController < ApplicationController
  
  before_filter :signed_in_user
  before_filter :check_admin
  
  def index
    @country = Country.find(params[:country_id])
    unless @country.insurance?
      flash[:notice] = "National Insurance is switched off for this country"
      redirect_to user_path(current_user)
    else
      @settings = @country.insurance_settings.future_list
      session[:time_focus] = "future"
      @recent_adds = InsuranceSetting.total_recent(@country)
      @recent_updates = InsuranceSetting.total_updated(@country)
      @recent_add_checks = InsuranceSetting.recent_add_checks(@country)
      @recent_update_checks = InsuranceSetting.recent_update_checks(@country)
    end
  end
  
end
