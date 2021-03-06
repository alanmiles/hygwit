module InsuranceSetsHelper

  def insurance_sets_instruction_1
    "This form allows you to add or edit a set of National Insurance rates to take effect on the date you set here. Use this if 
     the government announces rate changes annually."
  end
  
  def insurance_sets_instruction_2
    "First make sure the codes and salary settings for the date are up-to-date.  Then enter the date and click 'Create'.
     If no rates have been set for this date, HR2.0 will loop through the insurance codes and salary bands and create a new 
     record for each combination.  You then simply add the actual rates on the form displayed."
  end
  
  def insurance_sets_instruction_3
    "Any rates you've already set for the date will remain unchanged - and no new record will be created for the code/salary
    band combination.  So you can also use the form to edit all the rates for the date you enter."
  end
  
  def insurance_sets_listing_1
    "This should be the full list of all the Code-Salary Band combinations you've just set to commence on 
    #{session[:insurance_date].to_date.strftime('%d %b %y')}.  (The Code-Band code is the insurance code + the salary threshold
    setting for the band.)  You need to add the correct contribution rates - 'edit' each of the lines."
  end
  
  def insurance_sets_employees
    "These are the rates for EMPLOYEES.  Don't forget to deal with the rates for employer contributions too."
  end
  
  def insurance_sets_employers
    "These are the rates for EMPLOYERS."
  end
  
  def insurance_sets_listing_2
    "Make sure that the list includes all the codes and salary bands you'd expect.  If it doesn't, check the listings for insurance
    codes and salary settings and make sure everything's up-to-date and correct there - particularly if you've entered cancellations."
  end
  
  def insurance_sets_edit_instruction_1
    "Edit the rate or value of the insurance contribution here.  If you need to make some other change, delete the record 
    (from the list of new rates) and start again - by 'adding a single rate'."
  end
end
