module AbsenceCatsHelper

  def abscat_instruction_1
    "This is a list of the allowable ABSENCE TYPES for your business.  When you first set up the business, you'll see a 
     number of typical entries for your country.  Add, delete and modify list-items to suit your business."
  end
  
  def abscat_instruction_2
    "Each entry has a code (max 4 characters), with a fuller explanation in 'Notes'.  'Paid(%)' shows how much the 
     employee is paid for this type of absence: 100% is fully paid; 0 means no pay at all; 50 means half-pay.  
     (These default values can be overridden as you enter employee absences.)"
  end
  
  def abscat_instruction_3
    "Also shown is whether this is a sickness absence and the maximum number of days permitted per year (- normally there'll be a limit
     on the number of sickness days on full pay.)  'Certify?' indicates whether the employee needs to show documentary evidence of the
     reason for absence."
  end
  
  def abscat_not_current
    "This absence type is not in your current list.  To reinstate it, check the 'Current?' box, then 'Save changes'."    
  end
  
  def abscat_instruction_delete
    "You'll see a delete ('del') link until you start using the absence type in employee records.  After that, you can't delete it or
     change the code - but you can go to the 'Edit' page and hide it from the current list if you want to stop administrators 
     using it in the future."
  end
  
  def abs_current
    "Uncheck the box if you want to stop using this type of absence.  It will then no longer appear in your list of current
     absence-types ... although older absence records will be unaffected.  To restore the absence type, simply check the box
     again."
  end
end
