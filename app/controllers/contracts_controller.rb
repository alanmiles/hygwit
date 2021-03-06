class ContractsController < ApplicationController
  
  before_filter :signed_in_user, except: [:update, :destroy]
  before_filter :illegal_action, only: [:update, :destroy]
  before_filter :check_admin
  
  def index
    @contracts = Contract.all
    @recent_adds = Contract.all_recent
    @recent_updates = Contract.all_updated
    @recent_add_checks = Contract.added_require_checks
    @recent_update_checks = Contract.updated_require_checks
  end

  def new
    @contract = Contract.new
    @contract.created_by = current_user.id
    @contract.updated_by = current_user.id
    @contract.checked = true if current_user.superuser?
  end
  
  def create
    @contract = Contract.new(params[:contract])
    if @contract.save
      flash[:success] = "'#{@contract.contract}' added"
      redirect_to contracts_path
    else
      @contract.created_by = current_user.id
      @contract.updated_by = current_user.id
      @contract.checked = true if current_user.superuser?
      render 'new'
    end
  end

  def edit
   @contract = Contract.find(params[:id])
   @contract.updated_by = current_user.id unless current_user.superuser? 
  end
  
  def update
    @contract = Contract.find(params[:id])
    if @contract.update_attributes(params[:contract])
      @contract.update_attributes(checked: false) unless current_user.superuser?
      flash[:success] = "'#{@contract.contract}' updated"
      redirect_to contracts_path
    else
      @contract.updated_by = current_user.id unless current_user.superuser? 
      render "edit"
    end
  end
  
  def destroy
    @contract = Contract.find(params[:id])
    if current_user.superuser?
      @contract.destroy
      flash[:success]= "'#{@contract.contract}' destroyed"
      redirect_to contracts_path
    else
      if @contract.created_by == current_user.id
        @contract.destroy
        flash[:success]= "'#{@contract.contract}' destroyed"
        redirect_to contracts_path
      else
        flash[:notice] = "Illegal action.  You can only remove contract-types you have created."
        redirect_to contracts_path
      end
    end
  end
end
