module GratuityFormulasHelper

  def gratuity_country_guidance
    "A rule for calculating EXPATRIATE LEAVER GRATUITIES for #{@country.country}."
  end
  
  def gratuities_country_instruction_1
    "Add the rules for calculating EXPATRIATE LEAVER GRATUITIES for #{@country.country}."
  end
  
  def gratuities_country_instruction_2
    "In country X, expatriates are paid the equivalent of 50% of 1 month's salary for each year of service if the company terminates
    the contract up to year 3, and 100% of 1 month's salary for each year of service thereafter.  But if an employee resigns, there's no
    gratuity up to year 3, a payment of 1/3 of the monthly salary from years 3 to 5, and 100% of the monthly salary thereafter.  The
    table would be:"
  end
  
  def gratuities_country_instruction_3 
    "0; 3; 50; 0"
  end
  
  def gratuities_country_instruction_4 
    "3; 5; 100; 33.33"
  end
  
  def gratuities_country_instruction_5 
    "5; 100 (i.e. any service period); 100; 100"
  end
  
  def recent_country_gratuities(country)
    @recent = GratuityFormula.total_recent(country)  #created within last 7 days
    if @recent > 0
      return "#{pluralize(@recent, 'addition')} (*) in past 7 days."
    else
      return "No recent additions." 
    end
  end
  
  def updated_country_gratuities(country)
    @updates = GratuityFormula.total_updated(country)  #updated within last 7 days
    if @updates > 0
      return "#{pluralize(@updates, 'update')} (^) in past 7 days."
    else
      return "No recent updates." 
    end
  end
end
