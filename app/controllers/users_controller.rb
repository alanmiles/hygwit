class UsersController < ApplicationController
  
  before_filter :signed_in_user, only: [:index, :edit, :update, :show, :destroy]
  before_filter :correct_user,   only: [:edit, :update, :show]
  before_filter :check_admin,    only: [:index, :destroy]
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    if @user.business_admin?
      @businesses = BusinessAdmin.where("user_id =?", @user.id)
    end
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to HYGWIT!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    if current_user.admin?
      @user.destroy
      flash[:success] = "#{@user.name} destroyed."
      redirect_to users_url
    else 
      flash[:notice] = "You're not permitted to delete user accounts."
      redirect_to root_path
    end
  end
  
  private
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
end
