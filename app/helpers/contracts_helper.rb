module ContractsHelper

  def recent_contracts
    @recent = Contract.total_recent  #created within last 7 days
    if @recent > 0
      return "#{pluralize(@recent, 'addition')} (*) in past 7 days."
    else
      return "No recent additions" 
    end
  end
  
  def updated_contracts
    @updates = Contract.total_updated  #updated within last 7 days
    if @updates > 0
      return "#{pluralize(@updates, 'update')} (^) in past 7 days."
    else
      return "No recent updates" 
    end
  end
end
