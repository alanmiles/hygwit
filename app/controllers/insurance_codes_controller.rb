class InsuranceCodesController < ApplicationController
 
  before_filter :check_admin
  before_filter :signed_in_user, except: [:update, :create, :destroy]
  before_filter :illegal_action, only: [:update, :create, :destroy]
  
  def index
    @country = Country.find(params[:country_id])
    unless @country.insurance?
      flash[:notice] = "National Insurance is switched off for this country"
      redirect_to user_path(current_user)
    else
      @codes = @country.insurance_codes.all
      @recent_adds = InsuranceCode.total_recent(@country)
      @recent_updates = InsuranceCode.total_updated(@country)
      @recent_add_checks = InsuranceCode.recent_add_checks(@country)
      @recent_update_checks = InsuranceCode.recent_update_checks(@country)
    end
  end
  
  def new
    @country = Country.find(params[:country_id]) 
    unless current_user.administrator?(@country.country) || current_user.superuser?
      country_admin_access
    else
      unless @country.insurance?
        flash[:notice] = "National Insurance is switched off for this country"
        redirect_to user_path(current_user)
      else
        @code = @country.insurance_codes.new
        @code.created_by = current_user.id
        @code.updated_by = current_user.id
        @code.checked = true if current_user.superuser?
        @edit = false
      end
    end
  end
  
  def create
    @country = Country.find(params[:country_id])
    unless current_user.administrator?(@country.country) || current_user.superuser?
      country_admin_access
    else
      unless @country.insurance?
        flash[:notice] = "National Insurance is switched off for this country"
        redirect_to user_path(current_user)
      else
        @code = @country.insurance_codes.new(params[:insurance_code])
        if @code.save
          flash[:success] = "Insurance codes for #{@country.country} have been updated with '#{@code.insurance_code}'."
          redirect_to country_insurance_codes_path(@country)
        else
          @code.created_by = current_user.id
          @code.updated_by = current_user.id
          @code.checked = true if current_user.superuser?
          @edit = false
          render 'new'
        end
      end
    end
  end

  def edit
    @code = InsuranceCode.find(params[:id])
    @country = Country.find(@code.country_id)
    unless current_user.administrator?(@country.country) || current_user.superuser?
      country_admin_access
    else
      unless @country.insurance?
        flash[:notice] = "National Insurance is switched off for this country"
        redirect_to user_path(current_user)
      else
        @code.updated_by = current_user.id unless current_user.superuser?  #superuser check doesn't change inputter reference
        @edit = true
      end
    end
  end
  
  def update
    @code = InsuranceCode.find(params[:id])
    @country = Country.find(@code.country_id)
    unless current_user.administrator?(@country.country) || current_user.superuser?
      country_admin_access
    else
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
    end     
  end
  
  def destroy
    @code = InsuranceCode.find(params[:id])
    @country = Country.find(@code.country_id)
    unless current_user.administrator?(@country.country) || current_user.superuser?
      country_admin_access
    else
      unless @country.insurance?
        flash[:notice] = "National Insurance is switched off for this country"
        redirect_to user_path(current_user)
      else
        @code.destroy
        flash[:success] = "Code '#{@code.insurance_code}' in insurance codes for #{@country.country} has been destroyed."
        redirect_to country_insurance_codes_path(@country)
      end
    end
  end
  
  private
    
    #def check_permitted
    #  unless @country.insurance?
    #    flash[:notice] = "National Insurance is switched off for this country"
    #    redirect_to user_path(current_user)
    #  end
    #end
end
