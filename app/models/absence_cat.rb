# == Schema Information
#
# Table name: absence_cats
#
#  id                     :integer          not null, primary key
#  business_id            :integer
#  absence_code           :string(255)
#  paid                   :integer          default(100)
#  sickness               :boolean          default(FALSE)
#  maximum_days_year      :integer
#  documentation_required :boolean          default(TRUE)
#  notes                  :string(255)
#  created_by             :integer
#  updated_by             :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  current                :boolean          default(TRUE)
#

class AbsenceCat < ActiveRecord::Base
  attr_accessible :absence_code, :created_by, :documentation_required, :maximum_days_year, 
  								:notes, :paid, :sickness, :updated_by, :current
  								
  belongs_to :business
  
  before_save	:upcase_abscode
  
  validates :business_id,				presence: true
  validates :absence_code,		  presence: true, length: { maximum: 4 }, uniqueness: { case_sensitive: true, scope: :business_id }
  validates :paid,							presence: true, numericality: { only_integer: true }, inclusion: 0..100
  validates :maximum_days_year,	inclusion: { in: 1..100, allow_nil: true }, numericality: { only_integer: true, allow_nil: true }
  validates :notes,							length: { maximum: 140 }
  validates :created_by,				numericality: { only_integer: true, allow_blank: true }
  
  default_scope order: 'absence_cats.absence_code ASC'
  
  private
  
    def upcase_abscode
      absence_code.upcase!
    end
end
