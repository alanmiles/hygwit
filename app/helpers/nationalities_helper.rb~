module NationalitiesHelper

  def link_message
    @unlinked = Nationality.total_unlinked
    if @unlinked == 0
      return "All nationalities linked to countries"
    else
      return "#{pluralize(@unlinked, 'nationality')} unlinked to countries." 
    end
  end
  
  def recent_nationalities
    @recent = Nationality.total_recent  #created within last 7 days
    if @recent > 0
      return "#{pluralize(@recent, 'nationality')} (*) added in past 7 days."
    else
      return "No recent additions" 
    end
  end
  
  def updated_nationalities
    @updates = Nationality.total_updated  #updated within last 7 days
    if @updates > 0
      return "#{pluralize(@updates, 'nationality')} (^) updated in past 7 days."
    else
      return "No recent updates" 
    end
  end
end
