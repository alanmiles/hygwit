module HolidaysHelper

  def holidays_country_instruction_1
  
    "Add the PUBLIC HOLIDAYS for the next 12 months or so for #{@country.country} - and then continue to keep the list up-to-date."
  
  end
  
  def holidays_country_instruction_2
  
    "In the Muslim world, of course, the religious holidays are determined by sighting of the moon.  For the purposes of HR2.0
    enter the most likely date in advance, and then AS SOON AS an official announcement is made, update the record if necessary.
    Your changes will be passed through to all businesses in #{@country.country}, so don't people down by delaying!"
  end
  
  def holidays_country_guidance
    "Make sure you're up-to-date with all the national holidays in the coming months for #{@country.country }."
  end
  
  def recent_country_holidays(country)
    @recent = Holiday.total_recent(country)  #created within last 7 days
    if @recent > 0
      return "#{@recent} additions (*) in past 7 days."
    else
      return "No recent additions." 
    end
  end
  
  def updated_country_holidays(country)
    @updates = Holiday.total_updated(country)  #updated within last 7 days
    if @updates > 0
      return "#{@updates} updates (^) in past 7 days."
    else
      return "No recent updates." 
    end
  end
end
