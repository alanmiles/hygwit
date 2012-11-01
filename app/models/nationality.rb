# == Schema Information
#
# Table name: nationalities
#
#  id          :integer          not null, primary key
#  nationality :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Nationality < ActiveRecord::Base
  attr_accessible :nationality
  
  validates :nationality, presence: true, length: { maximum: 50 },
  												uniqueness: { case_sensitive: false }
  												
  default_scope order: 'nationalities.nationality ASC'
end
