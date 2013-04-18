class BusinessesController < ApplicationController
  
  before_filter :signed_in_user
  
  def index
  end

  def new
    @business = Business.new(params[:id])
    @business.created_by = current_user.id
    @countries = Country.ready_to_use
    @sectors = Sector.ready_to_use
  end
  
  def create
    @business = Business.new(params[:business])
    if @business.save
      BusinessAdmin.create(business_id: @business.id, user_id: current_user.id, created_by: current_user.id, main_contact: true)
      flash[:success] = "'#{@business.name}' added"
      redirect_to @business
    else
      @countries = Country.ready_to_use
      @sectors = Sector.ready_to_use
      @business.created_by = current_user.id
      render 'new'
    end
  end

  def edit
  end

  def show
    @business = Business.find(params[:id])
  end
end
