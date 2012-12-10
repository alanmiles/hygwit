module CountryAbsencesHelper

  #include RecentCountryChange
  
  def absence_country_instruction_1
  
    "Add the ABSENCE TYPES that are likely to apply to businesses in #{@country.country} - though the rules may vary from business 
     to business."
  
  end
  
  def absence_country_instruction_2
  
    "When a new business is created in #{@country.country}, these codes will be added automatically.  The local administrator will
    then be able to make final adjustments so include the correct codes and values for the business."
  end
  
  def absence_country_guidance
  
    "Include all the absence types that are likely to apply to business in #{@country.country }."
  end
  
  def recent_country_absences(country)
    @recent = CountryAbsence.total_recent(country)  #created within last 7 days
    if @recent > 0
      return "#{pluralize(@recent, 'addition')} (*) in past 7 days."
    else
      return "No recent additions." 
    end
  end
  
  def updated_country_absences(country)
    @updates = CountryAbsence.total_updated(country)  #updated within last 7 days
    if @updates > 0
      return "#{pluralize(@updates, 'update')} (^) in past 7 days."
    else
      return "No recent updates." 
    end
  end
end
