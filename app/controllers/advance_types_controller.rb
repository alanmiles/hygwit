class AdvanceTypesController < ApplicationController
  before_filter :signed_in_user, except: [:update, :destroy]
  before_filter :illegal_action, only: [:update, :destroy]
  before_filter :check_admin
  
  def index
    @advances = AdvanceType.all
    @recent_adds = AdvanceType.all_recent
    @recent_updates = AdvanceType.all_updated
    @recent_add_checks = AdvanceType.added_require_checks
    @recent_update_checks = AdvanceType.updated_require_checks
  end

  def new
    @advance = AdvanceType.new
    @advance.created_by = current_user.id
    @advance.updated_by = current_user.id
    @advance.checked = true if current_user.superuser?
  end
  
  def create
    @advance = AdvanceType.new(params[:advance_type])
    if @advance.save
      flash[:success] = "'#{@advance.name}' added"
      redirect_to advance_types_path
    else
      @advance.created_by = current_user.id
      @advance.updated_by = current_user.id
      @advance.checked = true if current_user.superuser?
      render 'new'
    end
  end

  def edit
   @advance = AdvanceType.find(params[:id])
   @advance.updated_by = current_user.id unless current_user.superuser? 
  end
  
  def update
    @advance = AdvanceType.find(params[:id])
    if @advance.update_attributes(params[:advance_type])
      @advance.update_attributes(checked: false) unless current_user.superuser?
      flash[:success] = "'#{@advance.name}' updated"
      redirect_to advance_types_path
    else
      @advance.updated_by = current_user.id unless current_user.superuser? 
      render "edit"
    end
  end
  
  def destroy
    @advance = AdvanceType.find(params[:id])
    if current_user.superuser?
      @advance.destroy
      flash[:success]= "'#{@advance.name}' destroyed"
      redirect_to advance_types_path
    else
      if @advance.created_by == current_user.id
        @advance.destroy
        flash[:success]= "'#{@advance.name}' destroyed"
        redirect_to advance_types_path
      else
        flash[:notice] = "Illegal action.  You can only remove advance types you have created."
        redirect_to advance_types_path
      end
    end
  end
end
