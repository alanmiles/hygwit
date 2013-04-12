class LoanTypesController < ApplicationController
  before_filter :signed_in_user, except: [:update, :destroy]
  before_filter :illegal_action, only: [:update, :destroy]
  before_filter :check_admin
  
  def index
    @loans = LoanType.all
    @recent_adds = LoanType.all_recent
    @recent_updates = LoanType.all_updated
    @recent_add_checks = LoanType.added_require_checks
    @recent_update_checks = LoanType.updated_require_checks
  end

  def new
    @loan = LoanType.new
    @loan.created_by = current_user.id
    @loan.updated_by = current_user.id
    @loan.checked = true if current_user.superuser?
  end
  
  def create
    @loan = LoanType.new(params[:loan_type])
    if @loan.save
      flash[:success] = "'#{@loan.name}' added"
      redirect_to loan_types_path
    else
      @loan.created_by = current_user.id
      @loan.updated_by = current_user.id
      @loan.checked = true if current_user.superuser?
      render 'new'
    end
  end

  def edit
   @loan = LoanType.find(params[:id])
   @loan.updated_by = current_user.id unless current_user.superuser? 
  end
  
  def update
    @loan = LoanType.find(params[:id])
    if @loan.update_attributes(params[:loan_type])
      @loan.update_attributes(checked: false) unless current_user.superuser?
      flash[:success] = "'#{@loan.name}' updated"
      redirect_to loan_types_path
    else
      @loan.updated_by = current_user.id unless current_user.superuser? 
      render "edit"
    end
  end
  
  def destroy
    @loan = LoanType.find(params[:id])
    if current_user.superuser?
      @loan.destroy
      flash[:success]= "'#{@loan.name}' destroyed"
      redirect_to loan_types_path
    else
      if @loan.created_by == current_user.id
        @loan.destroy
        flash[:success]= "'#{@loan.name}' destroyed"
        redirect_to loan_types_path
      else
        flash[:notice] = "Illegal action.  You can only remove loan types you have created."
        redirect_to loan_types_path
      end
    end
  end
end
