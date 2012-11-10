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
    @quality.approved = true if current_user.admin
  end
  
  def create
    @quality = Quality.new(params[:quality])
    if @quality.save
      flash[:success] = "'#{@quality.quality}' added"
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