class CurrenciesController < ApplicationController
  
  before_filter :signed_in_user, except: [:update, :destroy]
  before_filter :illegal_action, only: [:update, :destroy]
  before_filter :check_admin
  
  def index
    @currencies = Currency.all
    @recent_adds = Currency.all_recent
    @recent_updates = Currency.all_updated
    @recent_add_checks = Currency.added_require_checks
    @recent_update_checks = Currency.updated_require_checks 
  end

  def new
    @currency = Currency.new
    @currency.created_by = current_user.id
    @currency.updated_by = current_user.id
    @currency.checked = true if current_user.superuser?
  end
  
  def create
    @currency = Currency.new(params[:currency])
    if @currency.save
      flash[:success] = "'#{@currency.code}' added"
      redirect_to currencies_path
    else
      @currency.created_by = current_user.id
      @currency.updated_by = current_user.id
      @currency.checked = true if current_user.superuser?
      render 'new'
    end
  end

  def edit
   @currency = Currency.find(params[:id])
   @currency.updated_by = current_user.id unless current_user.superuser? 
  end
  
  def update
    @currency = Currency.find(params[:id])
    if @currency.update_attributes(params[:currency])
      @currency.update_attributes(checked: false) unless current_user.superuser?
      flash[:success] = "'#{@currency.code}' updated"
      redirect_to currencies_path
    else
      @currency.updated_by = current_user.id unless current_user.superuser? 
      render "edit"
    end
  end
  
  def destroy
    @currency = Currency.find(params[:id])
    if @currency.linked?
      flash[:notice] = "Illegal action"
      redirect_to root_path
    else
     if current_user.superuser?
        @currency.destroy
        flash[:success]= "'#{@currency.code}' destroyed"
        redirect_to currencies_path
      else
        if @currency.created_by == current_user.id
          @currency.destroy
          flash[:success]= "'#{@currency.code}' destroyed"
          redirect_to currencies_path
        else
          flash[:notice] = "Illegal action.  You can only remove currencies you have created."
          redirect_to currencies_path
        end
      end
    end
  end
  
end
