module SectorsHelper

  def sector_instruction_1
  
    "SECTORS are particularly important for recruitment.  When businesses advertise a vacancy, their country and sector will be
    shown but not the company name." 
  
  end
  
  def sector_instruction_2
    
    "To keep the Sectors list manageable, we're restricting it to 60 entries.  All new entries need to be approved by HROomph 
    before going live." 
  end
  
  def recent_sectors
    @recent = Sector.total_recent  #created within last 7 days
    if @recent > 0
      return "#{pluralize(@recent, 'addition')} (*) needing approval."
    else
      return "No additions needing approval" 
    end
  end
  
  def updated_sectors
    @updates = Sector.total_updated  #updated within last 7 days
    if @updates > 0
      return "#{pluralize(@updates, 'update')} (^) in past 7 days."
    else
      return "No recent updates" 
    end
  end
end
