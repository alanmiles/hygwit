class ContractCatsController < ApplicationController
  before_filter :signed_in_user, except: [:update, :create, :destroy]
  before_filter :illegal_action, only: [:update, :create, :destroy]
  
  def index
    @business = Business.find(params[:business_id])
    check_bizadmin
    @contract_cats = @business.contract_cats
  end

  def new
    @business = Business.find(params[:business_id])
    check_bizadmin
    @contract_cat = @business.contract_cats.new
    @contract_cat.created_by = current_user.id
    @contract_cat.updated_by = current_user.id
  end
  
  def create
    @business = Business.find(params[:business_id])
    if current_user.bizadmin?(@business)
      @contract_cat = @business.contract_cats.new(params[:contract_cat])
      if @contract_cat.save
        flash[:success] = "'#{@contract_cat.contract}' has been added."
        redirect_to business_contract_cats_path(@business)
      else
        @contract_cat.created_by = current_user.id
        @contract_cat.updated_by = current_user.id
        render 'new'
      end
    else
      flash[:notice] = "Sorry, you're not a registered officer for #{@business.name}."
      redirect_to user_path(current_user)
    end
  end

  def edit
    @contract_cat = ContractCat.find(params[:id])
    @contract_cat.updated_by = current_user.id
    @business = Business.find(@contract_cat.business_id)
    check_bizadmin
  end
  
  def update
    @contract_cat = ContractCat.find(params[:id])
    @business = Business.find(@contract_cat.business_id)
    if current_user.bizadmin?(@business)
      if @contract_cat.update_attributes(params[:contract_cat])
        flash[:success] = "'#{@contract_cat.contract}' has been updated."
        redirect_to business_contract_cats_path(@business)
      else
        @contract_cat.updated_by = current_user.id
        render 'edit'
      end
    else
      flash[:notice] = "Sorry, you're not a registered officer for #{@business.name}."
      redirect_to user_path(current_user)
    end    
  end
  
  def destroy
    @contract_cat = ContractCat.find(params[:id])
    @business = Business.find(@contract_cat.business_id)
    if current_user.bizadmin?(@business)
      @contract_cat.destroy
      flash[:success] = "'#{@contract_cat.contract}' has been deleted."
      redirect_to business_contract_cats_path(@business)
    else
      flash[:notice] = "Sorry, you're not a registered officer for #{@business.name}."
      redirect_to user_path(current_user)
    end
  end
end
