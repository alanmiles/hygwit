module DisciplinaryCategoriesHelper

  def disciplinary_instruction_1
    "Here we enter just a handful of typical DISCIPLINARY CATEGORIES - in any country.  When a new business is set up, 
    all these entries will automatically be added in the company account.  This will show local administrators what we
    mean by disciplinary categories.  They'll be able to add, edit, and delete categories to make the listing appropriate for their
    own businesses."
  end
  
  def recent_disciplinary_categories
    @recent = DisciplinaryCategory.total_recent  #created within last 7 days
    if @recent > 0
      return "#{pluralize(@recent, 'addition')} (*) in past 7 days."
    else
      return "No recent additions" 
    end
  end
  
  def updated_disciplinary_categories
    @updates = DisciplinaryCategory.total_updated  #updated within last 7 days
    if @updates > 0
      return "#{pluralize(@updates, 'update')} (^) in past 7 days."
    else
      return "No recent updates" 
    end
  end
end
