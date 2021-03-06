module OldJobsHelper

  def old_job_1
    "If the delete ('del') link appears, then the job has never been assigned to an employee, so it can be removed completely.  
     If 'del' does not appear, then the job was assigned to one of your former employees - and that's why it can't be deleted."
  end
  
  def old_job_2
    "If the department code appears in red, then the department is also no longer current.  If you decide to reactivate the job,
     you'll either need to reactivate the department too, or choose a new department."
  end
  
  def reactivate_job
    "To reactivate a job, go to the 'Edit' page, check the 'Current?' box, and save."
  end
end
