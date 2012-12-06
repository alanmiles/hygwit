module UpdateCheck  
  
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
  
end
