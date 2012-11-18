class NationalitiesController < ApplicationController
  
  before_filter :check_admin
  before_filter :signed_in_user, except: [:update, :destroy]
  before_filter :illegal_action, only: [:update, :destroy]
  
  def index
    @nationalities = Nationality.all
  end

  def new
    @nationality = Nationality.new
    @nationality.created_by = current_user.id
  end
  
  def create
    @nationality = Nationality.new(params[:nationality])
    if @nationality.save
      flash[:success] = "'#{@nationality.nationality}' added"
      redirect_to nationalities_path
    else
      @nationality.created_by = current_user.id
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
    @nationality = Nationality.find(params[:id])
    if @nationality.linked?
      flash[:notice] = "Illegal action"
      redirect_to root_path
    else
      if current_user.superuser?
        @nationality.destroy
        flash[:success]= "'#{@nationality.nationality}' destroyed"
        redirect_to nationalities_path
      else
        if @nationality.created_by == current_user.id
          @nationality.destroy
          flash[:success]= "'#{@nationality.nationality}' destroyed"
          redirect_to nationalities_path
        else
          flash[:notice] = "Illegal action.  You can only remove nationalities you have created."
          redirect_to nationalities_path
        end
      end
    end
  end
  
end
