module MyActiveRecordExtensions

  extend ActiveSupport::Concern

  # add your instance methods here
  def recent?
    created_at >= 7.days.ago
  end
  
  def updated?
    updated_at >= 7.days.ago && created_at < 7.days.ago
  end
  
  def add_check?
    checked == false && (created_at + 1.day >= updated_at)
  end
  
  def update_check?
    checked == false && (created_at + 1.day < updated_at)
  end
  
  def updater
    @updater = User.find_by_id(updated_by)
    unless @updater.nil?
      contributor = "#{@updater.name} (ID #{self.updated_by})"
    else
      contributor = "Unknown (ID #{self.updated_by})"
    end
    return contributor  
  end
  
  def update_status
    unless checked?
      if created_at + 1.day > updated_at
        return "Added #{created_at.strftime('%d %b %Y')} by #{updater}."
      else
        return "Updated #{updated_at.strftime('%d %b %Y')} by #{updater}."
      end
    end 
  end

  # add your static(class) methods here
  module ClassMethods
    def all_recent
      self.where("created_at >=?", 7.days.ago).count
    end
  
    def all_updated
      self.where("updated_at >=? and created_at <?", 7.days.ago, 7.days.ago).count
    end
    
    def added_require_checks
      self.where("checked = ? AND (updated_at - created_at) < INTERVAL '1 day'", false).count
    end
  
    def updated_require_checks
      self.where("checked = ? AND (updated_at - created_at) >= INTERVAL '1 day'", false).count
    end
    
    def total_recent(country)
    	self.where("country_id = ? and created_at >=?", country.id, 7.days.ago).count
  	end
  
  	def total_updated(country)
    	self.where("country_id = ? and updated_at >=? and created_at <?", country.id, 7.days.ago, 7.days.ago).count
  	end
  
  	def recent_add_checks(country)
    	self.where("country_id = ? AND checked = ? AND (updated_at - created_at) < INTERVAL '1 day'", country.id, false).count
  	end
  
  	def recent_update_checks(country)
    	self.where("country_id = ? AND checked = ? AND (updated_at - created_at) >= INTERVAL '1 day'", country.id, false).count
  	end 
  end
end

# include the extension 
ActiveRecord::Base.send(:include, MyActiveRecordExtensions)
