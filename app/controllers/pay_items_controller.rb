class PayItemsController < ApplicationController
  before_filter :signed_in_user, except: [:update, :destroy]
  before_filter :illegal_action, only: [:update, :destroy]
  before_filter :check_admin
  
  def index
    @payitems = PayItem.order("position")
    @recent_adds = PayItem.all_recent
    @recent_updates = PayItem.all_updated
    @recent_add_checks = PayItem.added_require_checks
    @recent_update_checks = PayItem.updated_require_checks
  end
  
  def sort
    params[:pay_item].each_with_index do |id, index|
      PayItem.update_all({position: index+1}, {id: id})
    end
    render nothing: true
  end

  def new
    @payitem = PayItem.new
    @payitem.created_by = current_user.id
    @payitem.updated_by = current_user.id
    @payitem.checked = true if current_user.superuser?
    @payitem.fixed = true
  end
  
  def create
    @payitem = PayItem.new(params[:pay_item])
    if @payitem.save
      flash[:success] = "'#{@payitem.item}' added"
      redirect_to pay_items_path
    else
      @payitem.created_by = current_user.id
      @payitem.updated_by = current_user.id
      @payitem.checked = true if current_user.superuser?
      @payitem.fixed = true
      render 'new'
    end
  end

  def edit
   @payitem = PayItem.find(params[:id])
   @payitem.updated_by = current_user.id unless current_user.superuser? 
   @payitem.fixed = true
  end
  
  def update
    @payitem = PayItem.find(params[:id])
    if @payitem.update_attributes(params[:pay_item])
      @payitem.update_attributes(checked: false) unless current_user.superuser?
      flash[:success] = "'#{@payitem.item}' updated"
      redirect_to pay_items_path
    else
      @payitem.updated_by = current_user.id unless current_user.superuser? 
      @payitem.fixed = true
      render "edit"
    end
  end
  
  def destroy
    @payitem = PayItem.find(params[:id])
    if current_user.superuser?
      @payitem.destroy
      flash[:success]= "'#{@payitem.item}' destroyed"
      redirect_to pay_items_path
    else
      if @payitem.created_by == current_user.id
        @payitem.destroy
        flash[:success]= "'#{@payitem.item}' destroyed"
        redirect_to pay_items_path
      else
        flash[:notice] = "Illegal action.  You can only remove payroll items you have created."
        redirect_to pay_items_path
      end
    end
  end
end
