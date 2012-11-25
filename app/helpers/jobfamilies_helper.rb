module JobfamiliesHelper

  def families_instruction_1
  
    "The meanings of company job-titles are not always obvious to an outsider, and this can be a problem when placing recruitment
     advertisements.  To solve the problem, HR2.0 asks businesses to assign each job-title to a more generic JOB FAMILY, which will
     make it clear to anyone."
    
  end
  
  def families_instruction_2
    
    "To keep the Job Families list manageable, we're restricting it to 300 entries.  All new entries need to be approved by HROomph 
     before going live." 
  end
  
  def recent_jobfamilies
    @recent = Jobfamily.total_recent  #created within last 7 days
    if @recent > 0
      return "#{pluralize(@recent, 'addition')} (*) in past 7 days."
    else
      return "No additions needing approval" 
    end
  end
  
  def updated_jobfamilies
    @updates = Jobfamily.total_updated  #updated within last 7 days
    if @updates > 0
      return "#{pluralize(@updates, 'update')} (*) in past 7 days."
    else
      return "No recent updates" 
    end
  end
end
