module EthnicGroupsHelper

  def ethnicity_country_instruction_1
    "The set-up for #{@country.country} states that businesses are required to report on the various ETHNIC GROUPS amongst 
     their employees."
  end
  
  def ethnicity_country_instruction_2
    "Add the ethnic groups that are needed for the official report submissions.  Note that if the government requires businesses
     only to report on the numbers of expats and nationals, no entries are required here.  But if the authorities ask about, say,
     the number of 'White', 'Black African', and Hispanic' workers, then these categories should be included."
  end
  
  def ethnicity_country_guidance
    "The set-up for #{@country.country} states that businesses are required to report on the various ETHNIC GROUPS amongst 
     their employees.  This list includes the groups that are required for the official reports."
  end
  
end
