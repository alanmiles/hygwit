module GrievanceTypesHelper

  def grievance_instruction_1
    "Here we enter just a handful of typical GRIEVANCE TYPES - in any country.  When a new business is set up, 
    all these entries will automatically be added in the company account.  This will show local administrators what we
    mean by grievance types.  They'll be able to add, edit, and delete list-items to make it appropriate for their
    own businesses."
  end
  
  def recent_grievance_types
    @recent = GrievanceType.total_recent  #created within last 7 days
    if @recent > 0
      return "#{pluralize(@recent, 'addition')} (*) in past 7 days."
    else
      return "No recent additions" 
    end
  end
  
  def updated_grievance_types
    @updates = GrievanceType.total_updated  #updated within last 7 days
    if @updates > 0
      return "#{pluralize(@updates, 'update')} (^) in past 7 days."
    else
      return "No recent updates" 
    end
  end
end
