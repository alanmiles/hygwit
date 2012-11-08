class LeavingReasonsController < ApplicationController
  
  before_filter :signed_in_user
  before_filter :check_admin
  
  def index
    @leaving_reasons = LeavingReason.all
  end

  def new
    @leaving_reason = LeavingReason.new
  end
  
  def create
    @leaving_reason = LeavingReason.new(params[:leaving_reason])
    if @leaving_reason.save
      flash[:success] = "'#{@leaving_reason.reason}' added"
      redirect_to leaving_reasons_path
    else
      render 'new'
    end
  end

  def edit
   @leaving_reason = LeavingReason.find(params[:id])
  end
  
  def update
    @leaving_reason = LeavingReason.find(params[:id])
    if @leaving_reason.update_attributes(params[:leaving_reason])
      flash[:success] = "'#{@leaving_reason.reason}' updated"
      redirect_to leaving_reasons_path
    else
      render "edit"
    end
  end
  
  def destroy
    @leaving_reason = LeavingReason.find(params[:id]).destroy
    flash[:success]= "'#{@leaving_reason.reason}' destroyed"
    redirect_to leaving_reasons_path
  end
end
