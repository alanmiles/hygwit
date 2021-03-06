class JobRanksController < ApplicationController
  
  before_filter :signed_in_user, except: [:update, :create, :destroy]
  before_filter :illegal_action, only: [:update, :create, :destroy]
  
  def index
    @business = Business.find(params[:business_id])
    check_bizadmin
    @ranks = @business.rank_cats
  end

  def sort
    params[:rank_cat].each_with_index do |id, index|
      RankCat.update_all({position: index+1}, {id: id})
    end
    render nothing: true
  end

  def new
    @business = Business.find(params[:business_id])
    check_bizadmin
    @rank = @business.rank_cats.new
    @rank.created_by = current_user.id
    @rank.updated_by = current_user.id
  end
  
  def create
    @business = Business.find(params[:business_id])
    if current_user.bizadmin?(@business)
      @rank = @business.rank_cats.new(params[:rank_cat])
      if @rank.save
        flash[:success] = "'#{@rank.rank}' has been added."
        redirect_to business_job_ranks_path(@business)
      else
        @rank.created_by = current_user.id
        @rank.updated_by = current_user.id
        render 'new'
      end
    else
      flash[:notice] = "Sorry, you're not a registered officer for #{@business.name}."
      redirect_to user_path(current_user)
    end
  end

  def edit
    @rank = RankCat.find(params[:id])
    @rank.updated_by = current_user.id
    @business = Business.find(@rank.business_id)
    check_bizadmin
  end
  
  def update
    @rank = RankCat.find(params[:id])
    @business = Business.find(@rank.business_id)
    if current_user.bizadmin?(@business)
      if @rank.update_attributes(params[:rank_cat])
        flash[:success] = "'#{@rank.rank}' has been updated."
        redirect_to business_job_ranks_path(@business)
      else
        @rank.updated_by = current_user.id
        render 'edit'
      end
    else
      flash[:notice] = "Sorry, you're not a registered officer for #{@business.name}."
      redirect_to user_path(current_user)
    end    
  end
  
  def destroy
    @rank = RankCat.find(params[:id])
    @business = Business.find(@rank.business_id)
    if current_user.bizadmin?(@business)
      @rank.destroy
      flash[:success] = "'#{@rank.rank}' has been deleted."
      redirect_to business_job_ranks_path(@business)
    else
      flash[:notice] = "Sorry, you're not a registered officer for #{@business.name}."
      redirect_to user_path(current_user)
    end
  end
end
