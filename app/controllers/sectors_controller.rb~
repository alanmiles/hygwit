class SectorsController < ApplicationController
  
  before_filter :signed_in_user
  before_filter :check_admin, only: :index
  
  def index
    @sectors = Sector.all
  end

  def new
    @sector = Sector.new
    @sector.created_by = current_user.id
    @sector.approved = true if current_user.admin
  end
  
  def create
    @sector = Sector.new(params[:sector])
    if @sector.save
      flash[:success] = "'#{@sector.sector}' added"
      redirect_to sectors_path
    else
      @sector.created_by = current_user.id
      render 'new'
    end
  end

  def edit
   @sector = Sector.find(params[:id])
  end
  
  def update
    @sector = Sector.find(params[:id])
    if @sector.update_attributes(params[:sector])
      flash[:success] = "'#{@sector.sector}' updated"
      redirect_to sectors_path
    else
      render "edit"
    end
  end
  
  def destroy
    @sector = Sector.find(params[:id]).destroy
    flash[:success]= "'#{@sector.sector}' destroyed"
    redirect_to sectors_path
  end
end
