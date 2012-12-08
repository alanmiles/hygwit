# == Schema Information
#
# Table name: insurance_codes
#
#  id             :integer          not null, primary key
#  country_id     :integer
#  insurance_code :string(255)
#  explanation    :string(255)
#  checked        :boolean          default(FALSE)
#  updated_by     :integer          default(1)
#  cancelled      :date
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  created_by     :integer          default(1)
#

class InsuranceCode < ActiveRecord::Base

  include UpdateCheck
  
  attr_accessible :explanation, :checked, :insurance_code, :updated_by, :cancelled, :created_by
  
  belongs_to :country
  
  validates :country_id,								presence: true
  validates :insurance_code,            presence: true, length: { maximum: 5 }, uniqueness: { case_sensitive: false, scope: :country_id }
  validates :explanation,								presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false, scope: :country_id }
  validates :created_by,								presence: true, numericality: { integer: true }

  def recent?
    created_at >= 7.days.ago
  end
  
  def self.total_recent(country)
    self.where("country_id = ? and created_at >=?", country.id, 7.days.ago).count
  end
  
  def updated?
    updated_at >= 7.days.ago && created_at < 7.days.ago
  end
  
  def self.total_updated(country)
    self.where("country_id = ? and updated_at >=? and created_at <?", country.id, 7.days.ago, 7.days.ago).count
  end
  
  def add_check?
    checked == false && (created_at + 1.day >= updated_at)
  end
  
  def self.recent_add_checks(country)
    self.where("country_id = ? AND checked = ? AND (updated_at - created_at) < INTERVAL '1 day'", country.id, false).count
  end
  
  def update_check?
    checked == false && (created_at + 1.day < updated_at)
  end
  
  def self.recent_update_checks(country)
    self.where("country_id = ? AND checked = ? AND (updated_at - created_at) >= INTERVAL '1 day'", country.id, false).count
  end

end
