module LeavingReasonsHelper

  def leaving_instruction_1
    "LEAVING REASONS help businesses to analyze why employees are leaving, but can also be important to help us to automate
    final settlement calculations. It matters whether the employee made the decision to leave themselves or whether their
    employment was terminated by the company." 
  end
  
  def recent_leaving_reasons
    @recent = LeavingReason.total_recent  #created within last 7 days
    if @recent > 0
      return "#{pluralize(@recent, 'addition')} (*) in past 7 days."
    else
      return "No recent additions" 
    end
  end
  
  def updated_leaving_reasons
    @updates = LeavingReason.total_updated  #updated within last 7 days
    if @updates > 0
      return "#{pluralize(@updates, 'update')} (^) in past 7 days."
    else
      return "No recent updates" 
    end
  end
  
end
