# == Schema Information
#
# Table name: ethnic_groups
#
#  id                :integer          not null, primary key
#  country_id        :integer
#  ethnic_group      :string(255)
#  checked           :boolean          default(FALSE)
#  created_by        :integer          default(1)
#  updated_by        :integer          default(1)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  cancellation_date :date
#

class EthnicGroup < ActiveRecord::Base

  attr_accessible :checked, :created_by, :ethnic_group, :updated_by, :cancellation_date
  
  belongs_to :country
  
  validates :country_id,				presence: true
  validates :ethnic_group,		  presence: true, length: { maximum: 30 }, uniqueness: { scope: :country_id, case_sensitive: false }
  validates :created_by,				presence: true, numericality: { only_integer: true }
  
  default_scope order: 'ethnic_groups.ethnic_group'
 
 
  def self_ref
    ethnic_group
  end
end
