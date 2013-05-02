module OldDepartmentsHelper

  def old_dept_1
    "If the delete ('del') link appears, then the department has no links to any jobs, so it can be removed completely.  If 'del'
     does not appear, then the department is still attached to a job - one no longer in use - and that's why it can't be deleted."
  end
  
  def old_dept_2
    "To reactivate a department, simply check the 'Current?' button and then 'Save changes'.  Note that its division must also 
     be current for this to work."
  end
end
