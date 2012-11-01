class NationalitiesController < ApplicationController
  
  before_filter :check_admin
  before_filter :signed_in_user
  
  def index
    @nationalities = Nationality.all
  end

  def new
    @nationality = Nationality.new
  end
  
  def create
    @nationality = Nationality.new(params[:nationality])
    if @nationality.save
      flash[:success] = "'#{@nationality.nationality}' added"
      redirect_to nationalities_path
    else
      render 'new'
    end
  end

  def edit
   @nationality = Nationality.find(params[:id])
  end
  
  def update
    @nationality = Nationality.find(params[:id])
    if @nationality.update_attributes(params[:nationality])
      flash[:success] = "'#{@nationality.nationality}' updated"
      redirect_to nationalities_path
    else
      render "edit"
    end
  end
  
  def destroy
    @nationality = Nationality.find(params[:id]).destroy
    flash[:success]= "'#{@nationality.nationality}' destroyed"
    redirect_to nationalities_path
  end
  
end
