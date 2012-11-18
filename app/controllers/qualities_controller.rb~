class QualitiesController < ApplicationController
  
  before_filter :signed_in_user
  before_filter :check_admin, only: :index
  
  def index
    @qualities = Quality.all
  end
  
  def show
    @quality = Quality.find(params[:id])
    @descriptors = @quality.descriptors
  end

  def new
    @quality = Quality.new
    @quality.created_by = current_user.id
    @quality.approved = true if current_user.superuser?
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
      render 'new'
    end
  end

  def edit
   @quality = Quality.find(params[:id])
  end
  
  def update
    @quality = Quality.find(params[:id])
    if @quality.update_attributes(params[:quality])
      flash[:success] = "'#{@quality.quality}' updated"
      redirect_to @quality
    else
      render "edit"
    end
  end
  
  def destroy
    @quality = Quality.find(params[:id]).destroy
    flash[:success]= "'#{@quality.quality}' destroyed"
    redirect_to qualities_path
  end
end
