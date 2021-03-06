class SectorsController < ApplicationController
  
  before_filter :signed_in_user, except: [:update, :destroy]
  before_filter :illegal_action, only: [:update, :destroy]
  before_filter :check_admin
  
  def index
    @sectors = Sector.all
    @recent_adds = Sector.all_recent
    @recent_updates = Sector.all_updated
    @recent_add_checks = Sector.added_require_checks
    @recent_update_checks = Sector.updated_require_checks
  end

  def new
    @sector = Sector.new
    @sector.created_by = current_user.id
    @sector.updated_by = current_user.id
    @sector.checked = true if current_user.superuser?
  end
  
  def create
    @sector = Sector.new(params[:sector])
    if @sector.save
      flash[:success] = "'#{@sector.sector}' added"
      redirect_to sectors_path
    else
      @sector.created_by = current_user.id
      @sector.updated_by = current_user.id
      @sector.checked = true if current_user.superuser?
      render 'new'
    end
  end

  def edit
   @sector = Sector.find(params[:id])
   @sector.updated_by = current_user.id unless current_user.superuser? 
  end
  
  def update
    @sector = Sector.find(params[:id])
    if @sector.update_attributes(params[:sector])
      @sector.update_attributes(checked: false) unless current_user.superuser?
      flash[:success] = "'#{@sector.sector}' updated"
      redirect_to sectors_path
    else
      @sector.updated_by = current_user.id unless current_user.superuser? 
      render "edit"
    end
  end
  
  def destroy
    @sector = Sector.find(params[:id])
    if current_user.superuser?
      @sector.destroy
      flash[:success]= "'#{@sector.sector}' destroyed"
      redirect_to sectors_path
    else
      if @sector.created_by == current_user.id
        @sector.destroy
        flash[:success]= "'#{@sector.sector}' destroyed"
        redirect_to sectors_path
      else
        flash[:notice] = "Illegal action.  You can only remove sectors you have created."
        redirect_to sectors_path
      end
    end
  end
end
