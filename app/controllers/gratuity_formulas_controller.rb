class GratuityFormulasController < ApplicationController
  
  before_filter :signed_in_user, except: [:update, :create, :destroy]
  before_filter :illegal_action, only: [:update, :create, :destroy]
  before_filter :check_admin
  
  def index
    @country = Country.find(params[:country_id])
    check_permitted
    @formulas = @country.gratuity_formulas.all
    @recent_adds = GratuityFormula.total_recent(@country)
    @recent_updates = GratuityFormula.total_updated(@country)
    @recent_add_checks = GratuityFormula.recent_add_checks(@country)
    @recent_update_checks = GratuityFormula.recent_update_checks(@country)
  end
  
  def new
    @country = Country.find(params[:country_id]) 
    country_admin_access
    check_permitted
    @formula = @country.gratuity_formulas.new
    @formula.created_by = current_user.id
    @formula.updated_by = current_user.id
    @formula.checked = true if current_user.superuser?
  end
  
  def create
    @country = Country.find(params[:country_id])
    check_permitted
    if current_user.superuser? || current_user.administrator?(@country.country)
      @formula = @country.gratuity_formulas.new(params[:gratuity_formula])
      if @formula.save
        flash[:success] = "Gratuity table for #{@country.country} has been updated."
        redirect_to country_gratuity_formulas_path(@country)
      else
        @formula.created_by = current_user.id
        @formula.updated_by = current_user.id
        @formula.checked = true if current_user.superuser?
        render 'new'
      end
    else
      flash[:notice] = "You must be a registered administrator for #{@country.country}."
      redirect_to user_path(current_user) 
    end
  end

  def edit
    @formula = GratuityFormula.find(params[:id])
    @country = Country.find(@formula.country_id)
    country_admin_access
    @formula.updated_by = current_user.id unless current_user.superuser? 
  end
  
  def update
    @formula = GratuityFormula.find(params[:id])
    @country = Country.find(@formula.country_id)
    if current_user.superuser? || current_user.administrator?(@country.country)
      if @formula.update_attributes(params[:gratuity_formula])
        @formula.update_attributes(checked: false) unless current_user.superuser?
        flash[:success] = "Gratuity table for #{@country.country} has been updated."
        redirect_to country_gratuity_formulas_path(@country)
      else
        @formula.updated_by = current_user.id unless current_user.superuser? 
        render 'edit'
      end
    else
      flash[:notice] = "You must be a registered administrator for #{@country.country} to make changes."
      redirect_to user_path(current_user)
    end
  end
  
  def destroy
    @formula = GratuityFormula.find(params[:id])
    @country = Country.find(@formula.country_id)
    if current_user.superuser? || current_user.administrator?(@country.country)
      @formula.destroy
      flash[:success] = "Line in the gratuity table for #{@country.country} destroyed."
      redirect_to country_gratuity_formulas_path(@country)
    else
      flash[:notice] = "You must be a registered administrator for #{@country.country} to make changes."
      redirect_to user_path(current_user)
    end
  end
  
  private
    
    def check_permitted
      unless @country.gratuity_applies?
        flash[:notice] = "Leaver gratuities are switched off for this country"
        redirect_to user_path(current_user)
      end
    end
end
