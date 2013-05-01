module DivisionsHelper

  def division_instruction_1
    "Divisions are optional.  Use them if you want to group a number of departments together for analysis purposes.
     For example, you might want to total the headcount or the employment costs for all your administrative or 
     production departments."
  end
  
  def division_instruction_2
    "This division has no related current departments, so perhaps it is no longer used.  If so, then uncheck the 'Current?' 
     box to remove it from the Divisions listing. Later, if you want to, you'll be able to re-activate the division later."
  end
  
  def division_instruction_3
    "Division names must be no longer than 25 characters."    
  end
  
  def division_instruction_4
    "This division is not in your current list.  To reinstate it, check the 'Current?' box, then 'Save changes'."    
  end
end