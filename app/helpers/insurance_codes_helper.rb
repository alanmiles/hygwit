module InsuranceCodesHelper

  
  def insurance_codes_country_guidance
    "INSURANCE CODES are assigned to each employee (normally by the national tax/insurance authorities) and help to determine
    the rate at which salary deductions are made for National Insurance. For example, there may be different codes for those 
    above pension age, or for expatriates, or for those who make contributions to a salary-related private 
    insurance scheme."
  end
  
  def code_fix_note
    "After the code has been entered, it can't be changed.  However, if you've just entered it and realized you've made a 
    mistake, you can still delete it (go to 'All codes').  Or if the government announces it no longer applies, then you
    can enter a cancellation date below.  HR2.0 clients in the country will then be automatically notified, so that they can 
    update their employees' insurance codes."
  end
  
  def explanation_help
    "Enter up to 50 characters to explain which employees the code applies to."
  end
  
  def cancel_help
    "If the government announces that the code is no longer to be used, enter the date when it'll no longer be valid - as soon
    as you get the news.  Businesses in the country will then be alerted that they may need to update employee insurance codes
    before the date arrives. Everything else is automatic: HR2.0 will stop using the code for insurance calculations from the
    cancellation date onwards."
  end
  
  def code_guidance
    "In 5 characters or less, enter the insurance code, preferably the same one assigned to employees in the government's 
    insurance scheme (so it'll easily be understood by HR2.0 users in the country).  The codes can be cancelled (if the
    government announces they're no longer in use), but not edited after companies start using them, so choose them with care."
  end
end
