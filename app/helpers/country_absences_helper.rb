module CountryAbsencesHelper

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
end
