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
  
  def insurance_settings_new_1
    "Use this form to enter a National Insurance salary threshold setting if:"
  end
  
  def insurance_settings_new_2
    "1.  The code has never been used in this country before, OR"
  end
  
  def insurance_settings_new_3
    "2.  The code has been used but you want to change its threshold values from a new effective date."
  end
  
  def insurance_settings_new_4
    "If you're updating the threshold values for ALL the current insurance codes, it's quicker and easier to click on the 'Update all 
     settings' on the 'Current thresholds list' page."
  end
  
  def insurance_settings_edit_1
    "Use this form to edit a National Insurance salary threshold setting if:"
  end
  
  def insurance_settings_edit_2
    "1.  The threshold values have been entered incorrectly, OR"
  end
  
  def insurance_settings_edit_3
    "2.  The code is being cancelled - and will not be used in the future."
  end
  
  def insurance_settings_edit_4
    "DO NOT edit the threshold values when changes are announced.  Instead use the button on the 'Current thresholds list
     page to 'Update all current settings'.  It's important not to overwrite the old settings in case back-dated adjustments
     are required."
  end
  
  def insurance_settings_cancel_1
    "Use this form to cancel a National Insurance salary threshold code and all its threshold settings if the 
     authorities announce that it will no longer be used."
  end
  
  def insurance_settings_cancel_2
    "After cancelling threshold codes, you'll need to remove them from your National Insurance Rates.  Go to
    the Rates form and 'add a new set of rates' with the same effective date as the cancellation date you enter here."
  end
  
  def insurance_settings_cancel_3
    "DO NOT CANCEL if the authorities announce new salary threshold values for the same code.  Instead, return to the 'Current
    thresholds list', then 'Update all settings'."
  end
  
  def insurance_settings_restore_1
    "Uh-oh!  Looks like someone's made a mistake.  If you've landed here, it's probably because this insurance salary threshold 
     code has been cancelled when it should still be in use.  To put things right again, keep a note
     of the cancellation date.  Then remove it and click on 'Save changes' to restore the salary threshold code and all its settings."
  end
  
  def insurance_settings_restore_2
    "If the threshold code was also removed from Insurance Rates, you'll need to add it back there too.  Go to
    the Insurance Rates form and 'add a new set of rates' with the same effective date as the cancellation date that
    you've noted."
  end
  
  def code_note
    "Enter a short-code for this setting, not more than 5 characters long.  If there's an official short-code used by the authorities, use
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
    "If the authorities announce that this code will no longer be used, enter the date from when it will no longer apply.  
     The code and all its threshold settings will remain in the history, but will no longer appear in the Current table 
     after the cancellation date.  Remove the cancellation date if you need to restore the code to the current list."
  end
  
  def cancellation_detail(setting)
    if setting.cancellation_date >= Date.today
      "(Cancelled from #{date_display(setting.cancellation_date)})"
    else
      "(Cancelled #{date_display(setting.cancellation_date)})"
    end
  end
  
  
end
