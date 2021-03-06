class AbsenceTypesController < ApplicationController

  before_filter :signed_in_user, except: [:update, :destroy]
  before_filter :illegal_action, only: [:update, :destroy]
  before_filter :check_admin
  
  def index
    @absences = AbsenceType.all
    @recent_adds = AbsenceType.all_recent
    @recent_updates = AbsenceType.all_updated
    @recent_add_checks = AbsenceType.added_require_checks
    @recent_update_checks = AbsenceType.updated_require_checks
  end

  def show
    @absence = AbsenceType.find(params[:id])
  end

  def new
    @absence = AbsenceType.new
    @absence.created_by = current_user.id
    @absence.updated_by = current_user.id
    @absence.checked = true if current_user.superuser?
  end
  
  def create
    @absence = AbsenceType.new(params[:absence_type])
    if @absence.save
      flash[:success] = "Absence code '#{@absence.absence_code}' added"
      redirect_to absence_types_path
    else
      @absence.created_by = current_user.id
      @absence.updated_by = current_user.id
      @absence.checked = true if current_user.superuser?
      render 'new'
    end
  end

  def edit
    @absence = AbsenceType.find(params[:id])
    @absence.updated_by = current_user.id unless current_user.superuser? 
  end
  
  def update
    @absence= AbsenceType.find(params[:id])
    if @absence.update_attributes(params[:absence_type])
      @absence.update_attributes(checked: false) unless current_user.superuser?
      flash[:success] = "Absence code '#{@absence.absence_code}' updated"
      redirect_to absence_types_path
    else
      @absence.updated_by = current_user.id unless current_user.superuser? 
      render "edit"
    end
  end
  
  def destroy
    @absence = AbsenceType.find(params[:id])
    if current_user.superuser?
      @absence.destroy
      flash[:success]= "'#{@absence.absence_code}' destroyed"
      redirect_to absence_types_path
    else
      if @absence.created_by == current_user.id
        @absence.destroy
        flash[:success]= "'#{@absence.absence_code}' destroyed"
        redirect_to absence_types_path
      else
        flash[:notice] = "Illegal action.  You can only remove absence-types you have created."
        redirect_to absence_types_path
      end
    end
  end
  
end
