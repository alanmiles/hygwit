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
    record.strftime('%d %b %Y')
  end
  
  def format_number(record)
    number_with_precision(record, :strip_insignificant_zeros => true)
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
end
