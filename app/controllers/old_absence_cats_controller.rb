class OldAbsenceCatsController < ApplicationController
  
  before_filter :signed_in_user
  
  def index
    @business = Business.find(params[:business_id])
    check_bizadmin
    @absence_cats = @business.former_absence_cats
  end
end
