module InsuranceRatesHelper
  
  def insurance_rates_country_instruction_1
    "National Insurance contributions from employees and employers are usually calculated as a percentage of gross salary (though
      sometimes they're a fixed amount).  The contribution is calculated by applying the rates shown in the INSURANCE RATES table, 
      taking account of (1) the employee's insurance code and (2) the salary band defined in the insurance thresholds table."
  end
  
  def insurance_rates_country_instruction_2
    "The HR2.0 approach allows you to pre-set Insurance Rates for the future, as well as keeping track of historic rates in case
    backdated adjustments are required later."
  end
  
  def insurance_rates_edit_instruction_1
    "You can adjust the insurance rate data below the line on this form.  In other words, you can change the rate or value of 
    the contribution, and, if this particular Code/Salary Band combination is withdrawn, you can set a cancellation date.  
    If you need to make some other change, delete the record (from the Rates listing) and create a new record entirely 
    ('Add a single rate')."
  end
  
  def insurance_rates_edit_instruction_2
    "If the rate is already in use, it may not be possible for you to delete.  If this happens, and you spot an error,
     let the HROomph team know, and we'll tidy up for you."
  end
  
  def insurance_rates_new_instruction_1
    "Use this form to add insurance rates one at a time.  But if you want to reset ALL insurance rates (for example, for an
    annual update), you'll find it quicker and easier to use 'Add a new set of rates' from the Current Rates page."
  end
  
  def insurance_rates_new_instruction_2
    "First enter the effective date for the new rate and click on 'Create'.  You'll then see the rest of the entry form.  Use the
    help (?) buttons for guidance."
  end
  
  def rebate_explain
    "Occasionally, the insurance rules state that as well as a contribution, there should be a rebate for certain insurance
     codes.  For example, in the UK, there are rebates for those who opt out of the goverment scheme and contribute to a 
     private pension.  Check 'Rebate' if this is the case for this entry.  Enter a positive number in 'Contribution', NOT A NEGATIVE
     NUMBER."
  end
  
  def contribution_explain
    "Normally, the insurance contribution calculation will be a percentage of the employee's gross salary.  If however the contribution
     is a fixed payment, not a percentage of salary, enter the amount in 'Contribution' and then check the 'Value' button."
  end
  
  def edate_explain
    "When did (or will) this rate take effect? You can enter a date in the future.  If you do, HR2.0 will automatically 
    apply the calculation formula, but not until the date arrives."
  end
  
  def threshold_explain
    "The select options for Salary Thresholds and Ceilings include the current settings and - if they've been entered - any
    future settings.  If there's more than one option, make sure you choose the right one as you enter or update the 
    insurance rate.  A threshold value must always be entered."
  end
  
  def ceiling_explain
    "This rate will be used to calculate the National Insurance for any salary greater than the threshold value, up to and including the
      ceiling value - also taking account of the employee's insurance code of course.  When you reach the highest salary
      milestone for the threshold salary, you can leave the Ceiling box blank - the rate will simply be applied to any salary value
      higher than the threshold."
  
  end
  
  def cancellation_explain
    "If a new rate has been announced for this Code/Salary Band combination, there's no need to enter a cancellation date.
    Just enter the new rate with its effective date, and the old rate will automatically pass to history.  The only time you need to 
    enter a cancellation date is if an insurance code or a salary band setting has been removed altogether ... so the Code/Salary
    Band combination is no longer applicable.  The combination will then be removed from calculations from the cancellation date."
  end
end
