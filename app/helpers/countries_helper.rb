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
  
  def superuser_incomplete
    "When a country administrator emails to tell you that the settings for #{@country.country} are complete, check the 'Completed'
    box at the bottom of the 'Edit Regulations' form ... after checking the entries.  Only a Superuser can see and check the
    'Completed' box.  After you've done this, local businesses can start entering their records and using the website."
  end
end
