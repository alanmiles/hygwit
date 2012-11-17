module AbsenceTypesHelper

  def absence_instruction_1
  
    "Here we add the ABSENCE TYPES that are likely to apply universally - though the rules (e.g the
     naximum number of days permitted) may vary from country to country."
  
  end
  
  def absence_instruction_2
  
    "When we set up a new country, these codes will be added automatically - but the list is then edited to take account of local
     legislation and practices."
  end
  
  def absence_instruction_3
  
    "Then, when a new business is added, the codes for the country are added automatically.  The local database manager makes final
     adjustments so that the correct codes and values are entered for the business."
  end
  
  def absence_guidance
  
    "Include only universal absence types - those that would normally apply in ANY country."
  end
  
  def recent_absence_types
    @recent = AbsenceType.total_recent  #created within last 7 days
    if @recent > 0
      return "#{pluralize(@recent, 'absence type')} (*) added in past 7 days."
    else
      return "No recent additions" 
    end
  end
  
  def updated_absence_types
    @updates = AbsenceType.total_updated  #updated within last 7 days
    if @updates > 0
      return "#{pluralize(@updates, 'absence type')} (^) updated in past 7 days."
    else
      return "No recent updates" 
    end
  end
end
