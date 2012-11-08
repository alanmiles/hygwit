class DescriptorsController < ApplicationController
  
  before_filter :signed_in_user
  
  def edit
    @descriptor = Descriptor.find(params[:id])
    @quality = Quality.find(@descriptor.quality_id)
  end
  
  def update
    @descriptor = Descriptor.find(params[:id])
    @quality = Quality.find(@descriptor.quality_id)
    @updater = current_user.id
    if @descriptor.update_attributes(params[:descriptor])
      @descriptor.update_attributes(updated_by: current_user.id, reviewed: false)
      flash[:success] = "Descriptor for Grade '#{@descriptor.grade}' updated"
      redirect_to @quality
    else
      render "edit"
    end
  end
end
