class QualitiesController < ApplicationController
  
  before_filter :signed_in_user
  before_filter :check_admin, only: :index
  
  def index
    @qualities = Quality.all
    @recent_adds = Quality.all_recent
    @recent_updates = Quality.all_updated
    @recent_add_checks = Quality.added_require_checks
    @recent_update_checks = Quality.updated_require_checks
  end
  
  def show
    @quality = Quality.find(params[:id])
    @descriptors = @quality.descriptors
  end

  def new
    @quality = Quality.new
    @quality.created_by = current_user.id
    @quality.updated_by = current_user.id
    @quality.checked = true if current_user.superuser?
  end
  
  def create
    @quality = Quality.new(params[:quality])
    if @quality.save
      if current_user.superuser?
        flash[:success] = "'#{@quality.quality}' added"
      else
        flash[:success] = "'#{@quality.quality}' added.  Now it will be checked by the HROomph team before it goes live."
      end
      redirect_to @quality
    else
      @quality.created_by = current_user.id
      @quality.updated_by = current_user.id
      @quality.checked = true if current_user.superuser?
      render 'new'
    end
  end

  def edit
   @quality = Quality.find(params[:id])
   @quality.updated_by = current_user.id unless current_user.superuser? 
  end
  
  def update
    @quality = Quality.find(params[:id])
    if @quality.update_attributes(params[:quality])
      @quality.update_attributes(checked: false) unless current_user.superuser?
      flash[:success] = "'#{@quality.quality}' updated"
      redirect_to @quality
    else
      @quality.updated_by = current_user.id unless current_user.superuser?
      render "edit"
    end
  end
  
  def destroy
    @quality = Quality.find(params[:id])
    if current_user.superuser?
      @quality.destroy
      flash[:success]= "'#{@quality.quality}' destroyed"
      redirect_to qualities_path
    else
      if @quality.created_by == current_user.id
        @quality.destroy
        flash[:success]= "'#{@quality.quality}' destroyed"
        redirect_to qualities_path
      else
        flash[:notice] = "Illegal action.  You can only remove qualities you have created."
        redirect_to qualities_path
      end
    end 
  end
end
