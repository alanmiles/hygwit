module DepartmentsHelper

  def department_instruction_1
    "Each job (and therefore each employee) needs to be allocated to a DEPARTMENT. This means you could have a secretary in
     the sales department and a secretary in the legal department too - HR2.0 will identify them as two different jobs."
  end
  
  def department_instruction_1a   
     "If no jobs (both current and historic) are related to the department, it can be deleted.  Otherwise it cannot, 
      although if none of its jobs are current, you can select the 'Edit' option and declare that it's also no longer current: 
      it will then no longer be displayed in this list."
  end
  
  def department_instruction_2
    "This department has no related current jobs, so perhaps it is no longer used.  If so, then uncheck the 'Current?' 
     box to remove it from the Departments listing. Later, if you want to, you'll be able to re-activate the department."
  end
  
  def department_instruction_3
    "Department names must be no longer than 25 characters.  Department codes should be 5 characters or fewer.  If you've
     entered divisions, then allocate the department to its division too - which will be useful for analysis later."    
  end
  
  def department_instruction_4
    "This department is not in your current list.  To reinstate it, check the 'Current?' box, then 'Save changes'.  (Note 
     that the division you select must also be current for this to work.)"    
  end
end
