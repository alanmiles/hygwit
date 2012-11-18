class CurrenciesController < ApplicationController
  
  before_filter :check_admin
  before_filter :signed_in_user, except: [:update, :destroy]
  before_filter :illegal_action, only: [:update, :destroy]
  
  def index
    @currencies = Currency.all
  end

  def new
    @currency = Currency.new
    @currency.created_by = current_user.id
  end
  
  def create
    @currency = Currency.new(params[:currency])
    if @currency.save
      flash[:success] = "'#{@currency.code}' added"
      redirect_to currencies_path
    else
      @currency.created_by = current_user.id
      render 'new'
    end
  end

  def edit
   @currency = Currency.find(params[:id])
  end
  
  def update
    @currency = Currency.find(params[:id])
    if @currency.update_attributes(params[:currency])
      flash[:success] = "'#{@currency.code}' updated"
      redirect_to currencies_path
    else
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
