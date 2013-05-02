class OldDepartmentsController < ApplicationController
  
  before_filter :signed_in_user
  
  def index
    @business = Business.find(params[:business_id])
    check_bizadmin
    @departments = @business.former_departments
  end
end
