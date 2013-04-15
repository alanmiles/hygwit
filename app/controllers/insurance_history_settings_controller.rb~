class InsuranceHistorySettingsController < ApplicationController
  
  before_filter :check_admin
  before_filter :signed_in_user
  
  def index
    @country = Country.find(params[:country_id])
    unless @country.insurance?
      flash[:notice] = "National Insurance is switched off for this country"
      redirect_to user_path(current_user)
    else
      @settings = @country.insurance_settings.order("insurance_settings.effective_date DESC, insurance_settings.monthly_milestone")
      session[:time_focus] = "history"
      @recent_adds = InsuranceSetting.total_recent(@country)
      @recent_updates = InsuranceSetting.total_updated(@country)
      @recent_add_checks = InsuranceSetting.recent_add_checks(@country)
      @recent_update_checks = InsuranceSetting.recent_update_checks(@country)
    end
  end
  
end
