class InsuranceEmployerSetsController < ApplicationController
 
  def index
    #displays all the records that have been created on the effective date, allowing values to be updated - html or js
    @country = Country.find(params[:country_id])
    unless @country.insurance?
      flash[:notice] = "National Insurance is switched off for this country"
      redirect_to user_path(current_user)
    else
      session[:group_focus] = "employer"
      #@selection = @country.insurance_rates.where("source_employee = ?", false)
      if session[:insurance_date] == nil
        @apply_date = Date.today
      else
        @apply_date = session[:insurance_date] 
      end
      @rates = InsuranceRate.active_list(@country, false, @apply_date)
      @page_title = "New National Insurance Rates Set - Employers"
      @list_type = "are the new rates for employers"
      @focus = "employer"
    end
  end
end
