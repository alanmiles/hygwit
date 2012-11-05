class CurrenciesController < ApplicationController
  
  before_filter :check_admin
  before_filter :signed_in_user
  
  def index
    @currencies = Currency.all
  end

  def new
    @currency = Currency.new
  end
  
  def create
    @currency = Currency.new(params[:currency])
    if @currency.save
      flash[:success] = "'#{@currency.code}' added"
      redirect_to currencies_path
    else
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
    @currency = Currency.find(params[:id]).destroy
    flash[:success]= "'#{@currency.code}' destroyed"
    redirect_to currencies_path
  end
  
end