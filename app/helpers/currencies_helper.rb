module CurrenciesHelper

  def linked_currencies
    @unlinked = Currency.total_unlinked
    if @unlinked == 0
      return "All currencies linked to countries"
    else
      return "#{pluralize(@unlinked, 'currency')} unlinked to countries" 
    end
  end
  
  def recent_currencies
    @recent = Currency.total_recent  #created within last 7 days
    if @recent > 0
      return "#{pluralize(@recent, 'currency')} (*) added in past 7 days."
    else
      return "No recent additions" 
    end
  end
  
  def updated_currencies
    @updates = Currency.total_updated  #updated within last 7 days
    if @updates > 0
      return "#{pluralize(@updates, 'currency')} (^) updated in past 7 days."
    else
      return "No recent updates" 
    end
  end
  
end
