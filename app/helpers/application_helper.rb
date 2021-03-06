module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "HR2.0"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
  
  def date_display(record)
    if record.nil?
      return "-"
    else
      return record.strftime('%d %b %y')
    end
  end
  
  def date_display_long(record)
    if record.nil?
      return "-"
    else
      return record.strftime('%d %b %Y')
    end
  end
  
  def string_to_date(record)
    if record.nil
      return nil
    else 
      return record.to_date.strftime('%d %b %Y')
    end
  end
    
  def format_number(record)
    number_with_precision(record, :strip_insignificant_zeros => true)
  end
  
  def dec_place_number(record, dec)
    if dec == 2
      sprintf("%.2f", record)
    elsif dec == 3
      sprintf("%.3f", record)
    elsif dec == 1
      sprintf("%.1f", record)
    else
      sprintf("%.0f", record)
    end
  end
  
  def not_country_admin
    "You're not registered as an administrator for this country, so although you can view the settings, you can't change them.
    But please email us (write to lead@hroomph.com) if you spot errors."
  end
  
  def apply_country_admin
    "We're still looking for country administrators for #{@country.country}.  If you have expert knowledge of the local rules and
    regulations and you'd like to get involved, please contact us at lead@hroomph.com and introduce yourself."
  end
  
  def extra_help
    "For extra help, click on" 
  end
  
  def help_text
    "Click on the icon for more guidance.  Click again to hide it."
  end
  
  def biz_abscodes
    "Enter a memorable, obvious code - up to 4 characters long - for this type of absence."  
  end
  
  def pay_percent
    "Enter a whole number which is the percentage of pay the employee receives when absent for this reason.  For example, if the
     employee still receives full pay, you'd enter 100; for half pay, enter 50; for zero pay, enter 0.  Your settings will be
     the default values, but deductions can be modified on a case-by-case basis as employee absences are entered.  
     Any deductions apply to basic salary ... but the same deductions can also apply to payroll benefits, depending on their settings 
     in 'Payroll items'."
  end
  
  def abs_sick
    "Sickness is distinguished from other types of absence.  Check the box if this absence should be included in 
     sickness calculations."
  end
  
  def max_absence
    "When 'maximum number of days per year' is set for an absence-type, HR2.0 monitors the number of days taken by each
     employee in a 12-month rolling period, and warn if someone tries to enter more absence days of this type than the maximum.  (It
     doesn't prevent extra days being added, but will issue a clear warning.)  If there's no maximum, just leave
     the box empty."
  end
  
  def docs_reqd
    "Check the box if the employee needs to provide documentary evidence for this type of absence before being paid for it.
     HR2.0 will then check that the document has been seen before payroll is finalized."
  end
  
  def abs_note
    "In fewer than 140 characters (and preferably much shorter), define this type of absence in fuil"
  end
  
end
