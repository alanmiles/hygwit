# == Schema Information
#
# Table name: holidays
#
#  id         :integer          not null, primary key
#  country_id :integer
#  name       :string(255)
#  start_date :date
#  end_date   :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  checked    :boolean          default(FALSE)
#  updated_by :integer          default(1)
#  created_by :integer          default(1)
#

class Holiday < ActiveRecord::Base

  include UpdateCheck
  
  attr_accessible :end_date, :name, :start_date, :checked, :updated_by, :created_by
  
  belongs_to :country
  
  validates :country_id,				presence: true
  validates :name,		  				presence: true, length: { maximum: 50 }
  validates :start_date, 				presence: true, uniqueness: { scope: :country_id }
  validates :end_date,					presence: true, uniqueness: { scope: :country_id }, false_end_date: true, one_week: true
  validates :created_by,				presence: true
  validate  :create_overlapping, on: :create
  validate  :update_overlapping, on: :update
  
  default_scope order: 'holidays.start_date DESC'
  
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
  
  private
    def create_overlapping
      unless Holiday.where(
          'country_id = ? AND((start_date <= ? AND end_date >= ?) OR (start_date >= ? AND start_date <= ?))',
          country_id,
          start_date, start_date,
          start_date, end_date
          ).empty?
        errors[:base] << 'This record overlaps with another'
      end
    end
      
    def update_overlapping  
      unless Holiday.where(
          'id != ? AND country_id = ? AND((start_date <= ? AND end_date >= ?) OR (start_date >= ? AND start_date <= ?))',
          self.id, country_id,
          start_date, start_date,
          start_date, end_date
          ).empty?
        errors[:base] << 'This record overlaps with another'
      end       
    end
end
