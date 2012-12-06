class InsuranceCodesController < ApplicationController
 
  
  before_filter :check_admin
  before_filter :signed_in_user, except: [:update, :create, :destroy]
  before_filter :illegal_action, only: [:update, :create, :destroy]
  
  def index
    @country = Country.find(params[:country_id])
    check_permitted
    @codes = @country.insurance_codes.all
    @recent_adds = InsuranceCode.total_recent(@country)
    @recent_updates = InsuranceCode.total_updated(@country)
    @recent_add_checks = InsuranceCode.recent_add_checks(@country)
    @recent_update_checks = InsuranceCode.recent_update_checks(@country)
  end
  
  def new
    @country = Country.find(params[:country_id]) 
    country_admin_access
    check_permitted
    @code = @country.insurance_codes.new
    @code.updated_by = current_user.id
    @code.checked = true if current_user.superuser?
    @edit = false
  end
  
  def create
    @country = Country.find(params[:country_id])
    check_permitted
    if current_user.superuser? || current_user.administrator?(@country.country)
      @code = @country.insurance_codes.new(params[:insurance_code])
      if @code.save
        flash[:success] = "Insurance codes for #{@country.country} have been updated with '#{@code.insurance_code}'."
        redirect_to country_insurance_codes_path(@country)
      else
        @code.updated_by = current_user.id
        @code.checked = true if current_user.superuser?
        @edit = false
        render 'new'
      end
    else
      flash[:notice] = "You must be a registered administrator for #{@country.country}."
      redirect_to user_path(current_user) 
    end
  end

  def edit
    @code = InsuranceCode.find(params[:id])
    @country = Country.find(@code.country_id)
    check_permitted
    country_admin_access
    @code.updated_by = current_user.id unless current_user.superuser?  #superuser check doesn't change inputter reference
    @edit = true
  end
  
  def update
    @code = InsuranceCode.find(params[:id])
    @country = Country.find(@code.country_id)
    if current_user.superuser? || current_user.administrator?(@country.country)
      unless @country.insurance?
        flash[:notice] = "National Insurance is switched off for this country"
        redirect_to user_path(current_user)
      else
        if @code.update_attributes(params[:insurance_code])
          @code.update_attributes(checked: false) unless current_user.superuser?
          flash[:success] = "Code '#{@code.insurance_code}' in insurance codes for #{@country.country} has been updated."
          redirect_to country_insurance_codes_path(@country)
        else
          @edit = true
          @code.updated_by = current_user.id unless current_user.superuser? 
          render 'edit'
        end
      end
    else 
      flash[:notice] = "You must be a registered administrator for #{@country.country} to make changes."
      redirect_to user_path(current_user)
    end      
  end
  
  def destroy
    @code = InsuranceCode.find(params[:id])
    @country = Country.find(@code.country_id)
    if current_user.superuser? || current_user.administrator?(@country.country)
      unless @country.insurance?
        flash[:notice] = "National Insurance is switched off for this country"
        redirect_to user_path(current_user)
      else  
        @code.destroy
        flash[:success] = "Code '#{@code.insurance_code}' in insurance codes for #{@country.country} has been destroyed."
        redirect_to country_insurance_codes_path(@country)
      end
    else
      flash[:notice] = "You must be a registered administrator for #{@country.country} to make changes."
      redirect_to user_path(current_user)
    end
  end
  
  private
    
    def check_permitted
      unless @country.insurance?
        flash[:notice] = "National Insurance is switched off for this country"
        redirect_to user_path(current_user)
      end
    end
end
