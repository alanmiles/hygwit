module InsuranceSettingsHelper

  def insurance_settings_country_guidance
    "SALARY THRESHOLDS are definitions of the salary levels at which different rates of payroll deduction are levied on employers 
     and employees for National Insurance in #{@country.country}.  For example, employees might be exempt from insurance if their
     salary is below a defined level."
  end
  
  def insurance_settings_country_instruction_1
    "SALARY THRESHOLDS are definitions of the salary levels at which different rates of payroll deduction are levied on employers 
     and employees for National Insurance in #{@country.country}."
  end
  
  #def recent_country_insurance_settings(country)
  #  @recent = InsuranceSetting.total_recent(country)  #created within last 7 days
  #  if @recent > 0
  #    return "#{pluralize(@recent, 'addition')} (*) in past 7 days."
  #  else
   #   return "No recent additions." 
  #  end
  #end
  
  #def updated_country_insurance_settings(country)
  #  @updates = InsuranceSetting.total_updated(country)  #updated within last 7 days
  #  if @updates > 0
  #    return "#{pluralize(@updates, 'update')} (^) in past 7 days."
  #  else
  #    return "No recent updates." 
  #  end
  #end
  
  def code_note
    "Enter a short-code for this setting, not more than 5 characters long.  If there's an official short-code used by your government, use
    that.  (For example, in the UK, the official codes are LEL, ST, PT, UAP and UEL.)" 
  end
  
  def name_note
    "Next, a longer description for this setting, up to 30 characters long.  Again use the official term if possible.
    (For example, in the UK, the official names are 'Lower Earnings Limit', 'Secondary Threshold', 'Primary Threshold' etc.)" 
  end
  
  def weekly_note
    "The official salary threshold for this setting for employees paid on a WEEKLY basis."
  end
  
  def monthly_note
    "The official salary threshold for this setting for employees paid on a MONTHLY basis."
  end
  
  def annual_note
    "The official salary threshold for this setting for employees whose salary totals are calculated on an ANNUAL 
    basis.  (Usually directors)"
  end
  
  def date_note
    "The date when these rules were (or will be) first applied.  In many countries, the salary thresholds are reset at the 
    beginning of each tax-year.  If the effective date is in the future, HR2.0 will ignore the new milestones until the 
    effective date arrives. Then it will apply the new milestone values automatically, and any old values will be stored in 
    the threshold history. (It's important for us to keep the older values - just in case adjustments need to be made to 
    an employee's deductions paid in a previous year.  So don't delete or edit the current milestones when changes 
    are announced - just add a new set with a new effective date."
  end
  
  def cancellation_note
    "If the government announces that this code will no longer be used, enter the date from when it will no longer apply.  
     The code and all its threshold settings will remain in the history, but will no longer appear in the Current table 
     after the cancellation date.  Remove the cancellation date if you need to restore the code to the current list."
  end
  
  def cancellation_detail(setting)
    if setting.cancellation_date >= Date.today
      "(CANCELLED from #{date_display(setting.cancellation_date)})"
    else
      "(CANCELLED #{date_display(setting.cancellation_date)})"
    end
  end
  
  
end
