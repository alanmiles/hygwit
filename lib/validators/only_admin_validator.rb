class OnlyAdminValidator < ActiveModel::EachValidator  
  def validate_each(record, attribute, value)  
    if record.user_id == nil
      record.errors[attribute] << "must include a user"
    else
      unless record.user.admin?
        record.errors[attribute] << "must already be an admin"  
      end
    end
  end  
end  
