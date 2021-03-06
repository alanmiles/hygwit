module QualitiesHelper

  def qualities_instruction_1
  
    "In HR2.0's Performance Management module, we ask businesses to define the 10 personality attributes likely to make 
    someone successful in each job.  The list is one of the tools we use for recruitment and performance reviews."
    
  end
  
  def qualities_instruction_2
    
    "This is the master list of QUALITIES, each with 5 performance DESCRIPTORS.  The descriptors have been carefully written
    to add objectivity to performance scoring."
    
  end
    
  def qualities_instruction_3 
    "To keep the Qualities list manageable, we're restricting it to 60 entries.  All new entries need to be approved by HROomph 
     before going live." 
  end
  
  #def recent_qualities
  #  @recent = Quality.total_recent  #created within last 7 days
  #  if @recent > 0
  #    return "#{pluralize(@recent, 'addition')} (*) needing approval."
  #  else
  #    return "No additions needing approval" 
  #  end
  #end
  
  #def updated_qualities
  #  @updates = Quality.total_updated  #updated within last 7 days
  #  if @updates > 0
  #    return "#{pluralize(@updates, 'update')} (*) in past 7 days."
  #  else
  #    return "No recent updates" 
  #  end
  #end
  
  def updated_descriptors
    if current_user.superuser?
      if Descriptor.requires_checking?
        @updates = Descriptor.total_unchecked
        return "#{pluralize(@updates, 'descriptor')} to check (&)."
      else
        "All updates have been checked"
      end
    else
      if Descriptor.includes_updates?
        @updates = Descriptor.count_updates
        return "#{pluralize(@updates, 'update')} in past 7 days (&)."
      else
        return "No recent updates" 
      end
    end
  end
  
  def incomplete_descriptors
    if Descriptor.requires_writing?
    @unchanged = Descriptor.total_unwritten
      "#{@unchanged} still to be written (~)."
    else
      return "All have been written" 
    end
  end
end
