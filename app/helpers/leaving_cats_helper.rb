module LeavingCatsHelper

  def leavingcat_instruction_1
    "This is a list of the allowable LEAVING REASONS for employees in your business.  When you first set up the business, 
     you'll see a number of typical reasons.  Add, delete and modify list-items to suit your business."
  end
  
  def leavingcat_instruction_2
    "As well as the reason for leaving, you'll see 'Full leaving benefits' next to some of the entries.  If this doesn't
    appear, then there may be deductions from an employee's leaving package ( - for example if the company uses a pension 
    scheme or pays a leaving indemnity, then this leaving reason may result in the full amount not being paid.)"  
  end
  
  def leavingcat_instruction_3
    "Add a LEAVING REASON - not more than 25 characters long.  No duplicate reasons are allowed."  
  end
  
  def leavingcat_instruction_4
    "Check the box if people who leave for this reason will be paid the full leaving package (eg - the entire pension or leaving
    indemnity if you use schemes like these and the employee is otherwise eligible.)  Leave the box blank if this reason for
    leaving may lead to deductions from the final payment.  (Don't worry about the actual deduction formulae - we define them 
    elsewhere.)"  
  end
end
