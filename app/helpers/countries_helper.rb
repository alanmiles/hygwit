module CountriesHelper

  def labor_law_instructions
    "Work through the form and fill in all the relevant entries in line with the Labor Law.  This will provide the
    basis for businesses in #{@country.country} to build their own settings pages."
  end
  
  def recent_countries
    @recent = Country.total_recent  #created within last 7 days
    if @recent > 0
      return "#{pluralize(@recent, 'country')} (*) added in past 7 days."
    else
      return "No recent additions" 
    end
  end
  
  def updated_countries
    @updates = Country.total_updated  #updated within last 7 days
    if @updates > 0
      return "#{pluralize(@updates, 'country')} (^) updated in past 7 days."
    else
      return "No recent updates" 
    end
  end
  
  def incomplete_countries
    @incomplete_records = Country.total_incomplete
    if @incomplete_records > 0
      return "#{pluralize(@incomplete_records, 'country setting')} (!) still incomplete."
    else
      return "All country set-up work has been done." 
    end
  end
  
  def admin_incomplete
    "As a country administrator it's your job to make sure that all the settings for #{@country.country} are consistent 
    with the Labor Law, now and in the future.  When you're sure everything is OK, please email us at support@hroomph.com 
    to let us know.  We'll then allow local businesses to start using the website."
  end
  
  def admin_complete
    "The settings for #{@country.country} are now complete, and local businesses can be added to the site.  But as a 
     country administrator, you should check at least once a month to make sure everything is still up-to date."
  end
  
  def superuser_complete
    "The settings for #{@country.country} are complete, but country administrators may continue to make changes.  You'll be
     alerted of any new additions and updates here.  Be sure to check back regularly and check that the updates are
     correct."
  end
  
  def completion
    "If the country name is in capitals, all the settings have been entered, so local businesses can start using HR2.0. 
    Otherwise, the country set-up is still incomplete."
  end
  
  def assist_as_country_admin
    "If you think you could help as a country administrator, click on the 'settings' link; in the sidebar. 
    It'll tell you whether we still need assistance."
  end
  
  def superuser_incomplete
    "When a country administrator emails to tell you that the settings for #{@country.country} are complete, check the 'Completed'
    box at the bottom of the 'Edit Regulations' form ... after checking the entries.  Only a Superuser can see and check the
    'Completed' box.  After you've done this, local businesses can start entering their records and using the website."
  end
  
  def ceiling_month
    "The law may state there's a maximum gratuity value based on the leaver's length of service.  For example, the maximum may be
    the employee's final monthly salary x 2 years.  If this is the case, enter the period IN MONTHS (so in this case, 24).  If 
    there's no rule like this, leave the box blank."
  end
  
  def ceiling_value
    "The law may state that there's a maximum value for gratuity payments.  If so, enter the number (not the currency); otherwise
    leave the box blank."
  end
  
  def sickness_accrual
    "Normally, employees are entitled to a certain number of sickness days on full- or half-pay per year.  When the year finishes,
    the slate is cleaned, and the calculation starts again.  But in some countries, the balance of sickness days not claimed for in
    one year may be carried forward to the next year.  If this is the case, check this box - and later you'll be asked to define
    the rules in detail."
  end
  
  def loan_percent
    "The law may define the maximum percentage of the monthly salary that the employer may deduct to reclaim loans and advances.  If
    so, enter the number (WITHOUT %).  Then, when businesses in the country enter new loans and advances and set the repayment 
    schedule, they'll be warned if the total deductions exceed the legal maximum.  If no maximum is defined in the law, leave
    the box blank."
  end
  
  def ramadan_hours
    "For Muslim workers."
  end
  
  def night_work
    "The law may define the hours for night-work - i.e. the hours when those working overtime should be paid at a higher rate.
    If the hours are defined, enter them in these two boxes.  If not, set both boxes to 12:00 AM."
  end
  
  def ot_rates
    "In the overtime rate boxes, enter the number used as the multiplier of the hourly salary rate to calculate the payment value.
    For example, if the rate is 'time and a quarter', enter 1.25 - for 'time and a half' enter 1.5 ." 
  end
  
  def gratuity_explanation
    "In other words, the amounts paid to employees - usually only to expatriates - at leaving, based on their length of service.  
    If you set gratuity to 'On' with this switch, 2 further questions will appear, asking about the ceilings (i.e. the 
    maximum payments) allowed by law."
  end
  
  def insurance_guide_1
    "HR2.0's universal National Insurance tool is designed to work in any country.  Simple to set-up and easy to adjust, the framework
    is controlled by a country administrator.  For the local business using HR2.0 national insurance contributions are then 
    calculated automatically." 
  end
  
  def insurance_guide_2
    "Set up the insurance rules for your country using the three links on the right - and then use the test tool to make sure
    everything is working properly.  Then, whenever new salary thresholds or rate adjustments are announced, update the records - 
    being particularly careful to ensure that the effective dates are correct.  It's an important job: all HR2.0 users in your
    country are depending on you."
  end 
end
