class OneWeekValidator < ActiveModel::EachValidator  
  def validate_each(record, attribute, value)  
    unless record.start_date.nil? || record.end_date.nil?
      if record.end_date - record.start_date > 6
        record.errors[attribute] << "must not be a week or more after start-date.  (Enter a 2nd record if necessary.)"
      end
    end
  end  
end  
