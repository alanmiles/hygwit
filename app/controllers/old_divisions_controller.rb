class OldDivisionsController < ApplicationController

  before_filter :signed_in_user
  
  def index
    @business = Business.find(params[:business_id])
    check_bizadmin
    @divisions = @business.former_divisions
  end
end
