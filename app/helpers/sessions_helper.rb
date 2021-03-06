module SessionsHelper

  def sign_in(user)
    if params[:remember_me]
      cookies.permanent[:remember_token] = user.remember_token
    else
      cookies[:remember_token] = user.remember_token  
    end
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token]) if cookies[:remember_token]
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end
  
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end
  
  def track_current(business)
    session[:biz] = business.id
  end
  
  def current_business
    Business.find(session[:biz])
  end
   
  def check_admin
    if signed_in?
      unless current_user.admin?
        redirect_to user_path(current_user), notice: "You must be a HROomph admin to issue this instruction."
      end 
    else
      store_location
      redirect_to signin_url, notice: "You must be a HROomph admin to issue this instruction." 
    end
  end
  
  def check_bizadmin
    if signed_in?
      bizadmin_check = BusinessAdmin.find_by_user_id_and_business_id(current_user.id, @business.id)
      if bizadmin_check.nil?
        flash[:notice] = "Sorry, you're not a registered officer for #{@business.name}."
        redirect_to user_path(current_user)
      end
    else
      redirect_to signin_url, notice: "You must be a signed-in business officer to issue this instruction."
    end
  end
  
  def check_superuser
    unless signed_in? 
      redirect_to signin_url, notice: "You must sign in and be a HROomph superuser to issue this instruction." 
    else  
      unless current_user.superuser?
        redirect_to user_path(current_user), notice: "You must be a HROomph superuser to issue this instruction." 
      end
    end
  end
  
  def illegal_action
    unless signed_in?
      redirect_to root_path, notice: "Illegal action"
    end
  end
  
  def country_admin_access
    if signed_in?
      unless current_user.superuser?
        admin_check = CountryAdmin.find_by_user_id_and_country_id(current_user.id, @country.id)
        if admin_check.nil?
          flash[:notice] = "You must be a registered administrator for #{@country.country} to make changes."
          redirect_to user_path(current_user)
        end
      end 
    end
  end
  
  def set_insset_cancellation_status
    unless @setting.cancellation_date == nil
      session[:insset_cancelled] = true
    else
      session[:insset_cancelled] = false
    end
  end
  
  def unset_insset_cancellation
    session[:insset_cancelled] = nil
  end
  
  def insset_cancellation_status_changed?
    session[:insset_cancelled] == true && !@setting.cancellation_date? || session[:insset_cancelled] == false && @setting.cancellation_date?
  end
  
end
