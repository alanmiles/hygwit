class DisciplinaryCatsController < ApplicationController
  
  before_filter :signed_in_user, except: [:update, :create, :destroy]
  before_filter :illegal_action, only: [:update, :create, :destroy]
  
  def index
    @business = Business.find(params[:business_id])
    check_bizadmin
    @disciplinary_cats = @business.disciplinary_cats
  end

  def new
    @business = Business.find(params[:business_id])
    check_bizadmin
    @disciplinary_cat = @business.disciplinary_cats.new
    @disciplinary_cat.created_by = current_user.id
    @disciplinary_cat.updated_by = current_user.id
  end
  
  def create
    @business = Business.find(params[:business_id])
    if current_user.bizadmin?(@business)
      @disciplinary_cat = @business.disciplinary_cats.new(params[:disciplinary_cat])
      if @disciplinary_cat.save
        flash[:success] = "'#{@disciplinary_cat.category}' has been added."
        redirect_to business_disciplinary_cats_path(@business)
      else
        @disciplinary_cat.created_by = current_user.id
        @disciplinary_cat.updated_by = current_user.id
        render 'new'
      end
    else
      flash[:notice] = "Sorry, you're not a registered officer for #{@business.name}."
      redirect_to user_path(current_user)
    end
  end

  def edit
    @disciplinary_cat = DisciplinaryCat.find(params[:id])
    @disciplinary_cat.updated_by = current_user.id
    @business = Business.find(@disciplinary_cat.business_id)
    check_bizadmin
  end
  
  def update
    @disciplinary_cat = DisciplinaryCat.find(params[:id])
    @business = Business.find(@disciplinary_cat.business_id)
    if current_user.bizadmin?(@business)
      if @disciplinary_cat.update_attributes(params[:disciplinary_cat])
        flash[:success] = "'#{@disciplinary_cat.category}' has been updated."
        redirect_to business_disciplinary_cats_path(@business)
      else
        @disciplinary_cat.updated_by = current_user.id
        render 'edit'
      end
    else
      flash[:notice] = "Sorry, you're not a registered officer for #{@business.name}."
      redirect_to user_path(current_user)
    end    
  end
  
  def destroy
    @disciplinary_cat = DisciplinaryCat.find(params[:id])
    @business = Business.find(@disciplinary_cat.business_id)
    if current_user.bizadmin?(@business)
      @disciplinary_cat.destroy
      flash[:success] = "'#{@disciplinary_cat.category}' has been deleted."
      redirect_to business_disciplinary_cats_path(@business)
    else
      flash[:notice] = "Sorry, you're not a registered officer for #{@business.name}."
      redirect_to user_path(current_user)
    end
  end
end
