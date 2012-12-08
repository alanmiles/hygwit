class DescriptorsController < ApplicationController
  
  before_filter :signed_in_user
  
  def edit
    @descriptor = Descriptor.find(params[:id])
    @quality = Quality.find(@descriptor.quality_id)
    if @descriptor.not_written?
      @descriptor.updated_by = current_user.id
    else
      @descriptor.updated_by = current_user.id unless current_user.superuser?
    end
  end
  
  def update
    @descriptor = Descriptor.find(params[:id])
    @quality = Quality.find(@descriptor.quality_id)
    #@updater = current_user.id
    if @descriptor.update_attributes(params[:descriptor])
      @descriptor.update_attributes(checked: false) unless current_user.superuser?
      flash[:success] = "Descriptor for Grade '#{@descriptor.grade}' updated"
      redirect_to @quality
    else
      if @descriptor.not_written?
        @descriptor.updated_by = current_user.id
      else
        @descriptor.updated_by = current_user.id unless current_user.superuser?
      end
      render "edit"
    end
  end
end
