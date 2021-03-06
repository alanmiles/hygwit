class OldJobsController < ApplicationController
  
  before_filter :signed_in_user
  
  def index
    @business = Business.find(params[:business_id])
    check_bizadmin
    @jobs = @business.former_jobs.paginate(page: params[:page])
  end
end
