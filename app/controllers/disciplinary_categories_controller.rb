class DisciplinaryCategoriesController < ApplicationController
  
  before_filter :signed_in_user, except: [:update, :destroy]
  before_filter :illegal_action, only: [:update, :destroy]
  before_filter :check_admin
  
  def index
    @disciplinary_cats = DisciplinaryCategory.all
  end

  def new
    @disciplinary_cat = DisciplinaryCategory.new
    @disciplinary_cat.created_by = current_user.id
  end
  
  def create
    @disciplinary_cat = DisciplinaryCategory.new(params[:disciplinary_category])
    if @disciplinary_cat.save
      flash[:success] = "'#{@disciplinary_cat.category}' added"
      redirect_to disciplinary_categories_path
    else
      @disciplinary_cat.created_by = current_user.id
      render 'new'
    end
  end

  def edit
   @disciplinary_cat = DisciplinaryCategory.find(params[:id])
  end
  
  def update
    @disciplinary_cat = DisciplinaryCategory.find(params[:id])
    if @disciplinary_cat.update_attributes(params[:disciplinary_category])
      flash[:success] = "'#{@disciplinary_cat.category}' updated"
      redirect_to disciplinary_categories_path
    else
      render "edit"
    end
  end
  
  def destroy
    @disciplinary_cat = DisciplinaryCategory.find(params[:id])
    if current_user.superuser?
      @disciplinary_cat.destroy
      flash[:success]= "'#{@disciplinary_cat.category}' destroyed"
      redirect_to disciplinary_categories_path
    else
      if @disciplinary_cat.created_by == current_user.id
        @disciplinary_cat.destroy
        flash[:success]= "'#{@disciplinary_cat.category}' destroyed"
        redirect_to disciplinary_categories_path
      else
        flash[:notice] = "Illegal action.  You can only remove disciplinary categories you have created."
        redirect_to disciplinary_categories_path
      end
    end 
  end
end
