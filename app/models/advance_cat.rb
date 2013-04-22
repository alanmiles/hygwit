# == Schema Information
#
# Table name: advance_cats
#
#  id          :integer          not null, primary key
#  business_id :integer
#  name        :string(255)
#  created_by  :integer
#  updated_by  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class AdvanceCat < ActiveRecord::Base
  attr_accessible :created_by, :name, :updated_by
  belongs_to :business
  
  validates :business_id,						presence: true
  validates :name, 									presence: true, length: { maximum: 20 },
                     									uniqueness: { case_sensitive: false, scope: :business_id }
                     									
  default_scope order: 'advance_cats.name ASC'
end
