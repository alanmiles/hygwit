module RecentChange 
  
  def recent?
    created_at >= 7.days.ago
  end
  
  def total_recent(country)
    self.where("country_id = ? and created_at >=?", country.id, 7.days.ago).count
  end
  
  def updated?
    updated_at >= 7.days.ago && created_at < 7.days.ago
  end
  
  def total_updated(country)
    self.where("country_id = ? and updated_at >=? and created_at <?", country.id, 7.days.ago, 7.days.ago).count
  end
  
  def add_check?
    checked == false && (created_at + 1.day >= updated_at)
  end
  
  def recent_add_checks(country)
    self.where("country_id = ? AND checked = ? AND (updated_at - created_at) < INTERVAL '1 day'", country.id, false).count
  end
  
  def update_check?
    checked == false && (created_at + 1.day < updated_at)
  end
  
  def recent_update_checks(country)
    self.where("country_id = ? AND checked = ? AND (updated_at - created_at) >= INTERVAL '1 day'", country.id, false).count
  end
  
end
