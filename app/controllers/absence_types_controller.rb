class AbsenceTypesController < ApplicationController

  before_filter :check_admin
  before_filter :signed_in_user, except: [:update, :destroy]
  before_filter :illegal_action, only: [:update, :destroy]
  
  def index
    @absences = AbsenceType.all
  end

  def show
    @absence = AbsenceType.find(params[:id])
  end

  def new
    @absence = AbsenceType.new
    @absence.created_by = current_user.id
  end
  
  def create
    @absence = AbsenceType.new(params[:absence_type])
    if @absence.save
      flash[:success] = "Absence code '#{@absence.absence_code}' added"
      redirect_to absence_types_path
    else
      @absence.created_by = current_user.id
      render 'new'
    end
  end

  def edit
    @absence = AbsenceType.find(params[:id])
  end
  
  def update
    @absence= AbsenceType.find(params[:id])
    if @absence.update_attributes(params[:absence_type])
      flash[:success] = "Absence code '#{@absence.absence_code}' updated"
      redirect_to absence_types_path
    else
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
