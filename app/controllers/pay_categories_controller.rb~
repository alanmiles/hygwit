class PayCategoriesController < ApplicationController
  before_filter :signed_in_user, except: [:update, :destroy]
  before_filter :illegal_action, only: [:update, :destroy]
  before_filter :check_admin
  
  def index
    @paycats = PayCategory.order("position")
    @recent_adds = PayCategory.all_recent
    @recent_updates = PayCategory.all_updated
    @recent_add_checks = PayCategory.added_require_checks
    @recent_update_checks = PayCategory.updated_require_checks
  end
  
  def sort
    params[:pay_category].each_with_index do |id, index|
      PayCategory.update_all({position: index+1}, {id: id})
    end
    render nothing: true
  end

  def new
    @paycat = PayCategory.new
    @paycat.created_by = current_user.id
    @paycat.updated_by = current_user.id
    @paycat.checked = true if current_user.superuser?
  end
  
  def create
    @paycat = PayCategory.new(params[:pay_category])
    if @paycat.save
      flash[:success] = "'#{@paycat.category}' added"
      redirect_to pay_categories_path
    else
      @paycat.created_by = current_user.id
      @paycat.updated_by = current_user.id
      @paycat.checked = true if current_user.superuser?
      render 'new'
    end
  end

  def edit
   @paycat = PayCategory.find(params[:id])
   @paycat.updated_by = current_user.id unless current_user.superuser? 
  end
  
  def update
    @paycat = PayCategory.find(params[:id])
    if @paycat.update_attributes(params[:pay_category])
      @paycat.update_attributes(checked: false) unless current_user.superuser?
      flash[:success] = "'#{@paycat.category}' updated"
      redirect_to pay_categories_path
    else
      @paycat.updated_by = current_user.id unless current_user.superuser? 
      render "edit"
    end
  end
  
  def destroy
    @paycat = PayCategory.find(params[:id])
    if current_user.superuser?
      @paycat.destroy
      flash[:success]= "'#{@paycat.category}' destroyed"
      redirect_to pay_categories_path
    else
      if @paycat.created_by == current_user.id
        @paycat.destroy
        flash[:success]= "'#{@paycat.category}' destroyed"
        redirect_to pay_categories_path
      else
        flash[:notice] = "Illegal action.  You can only remove payroll categories you have created."
        redirect_to pay_categories_path
      end
    end
  end
end
