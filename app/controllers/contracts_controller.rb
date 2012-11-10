class ContractsController < ApplicationController
  
  before_filter :signed_in_user, except: [:update, :destroy]
  before_filter :illegal_action, only: [:update, :destroy]
  before_filter :check_admin
  
  def index
    @contracts = Contract.all
  end

  def new
    @contract = Contract.new
  end
  
  def create
    @contract = Contract.new(params[:contract])
    if @contract.save
      flash[:success] = "'#{@contract.contract}' added"
      redirect_to contracts_path
    else
      render 'new'
    end
  end

  def edit
   @contract = Contract.find(params[:id])
  end
  
  def update
    @contract = Contract.find(params[:id])
    if @contract.update_attributes(params[:contract])
      flash[:success] = "'#{@contract.contract}' updated"
      redirect_to contracts_path
    else
      render "edit"
    end
  end
  
  def destroy
    @contract = Contract.find(params[:id]).destroy
    flash[:success]= "'#{@contract.contract}' destroyed"
    redirect_to contracts_path
  end
end
