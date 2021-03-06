class RanksController < ApplicationController
  
  before_filter :signed_in_user, except: [:update, :destroy]
  before_filter :illegal_action, only: [:update, :destroy]
  before_filter :check_admin
  
  def index
    @ranks = Rank.order("position")
    @recent_adds = Rank.all_recent
    @recent_updates = Rank.all_updated
    @recent_add_checks = Rank.added_require_checks
    @recent_update_checks = Rank.updated_require_checks
  end
  
  def sort
    params[:rank].each_with_index do |id, index|
      Rank.update_all({position: index+1}, {id: id})
    end
    render nothing: true
  end

  def new
    @rank = Rank.new
    @rank.created_by = current_user.id
    @rank.updated_by = current_user.id
    @rank.checked = true if current_user.superuser?
  end
  
  def create
    @rank = Rank.new(params[:rank])
    if @rank.save
      flash[:success] = "'#{@rank.rank}' added"
      redirect_to ranks_path
    else
      @rank.created_by = current_user.id
      @rank.updated_by = current_user.id
      @rank.checked = true if current_user.superuser?
      render 'new'
    end
  end

  def edit
   @rank = Rank.find(params[:id])
   @rank.updated_by = current_user.id unless current_user.superuser? 
  end
  
  def update
    @rank = Rank.find(params[:id])
    if @rank.update_attributes(params[:rank])
      @rank.update_attributes(checked: false) unless current_user.superuser?
      flash[:success] = "'#{@rank.rank}' updated"
      redirect_to ranks_path
    else
      @rank.updated_by = current_user.id unless current_user.superuser? 
      render "edit"
    end
  end
  
  def destroy
    @rank = Rank.find(params[:id])
    if current_user.superuser?
      @rank.destroy
      flash[:success]= "'#{@rank.rank}' destroyed"
      redirect_to ranks_path
    else
      if @rank.created_by == current_user.id
        @rank.destroy
        flash[:success]= "'#{@rank.rank}' destroyed"
        redirect_to ranks_path
      else
        flash[:notice] = "Illegal action.  You can only remove job-ranks you have created."
        redirect_to ranks_path
      end
    end
  end
end
