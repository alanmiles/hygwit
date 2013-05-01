# == Schema Information
#
# Table name: divisions
#
#  id          :integer          not null, primary key
#  business_id :integer
#  division    :string(255)
#  current     :boolean          default(TRUE)
#  created_by  :integer
#  updated_by  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Division < ActiveRecord::Base
  attr_accessible :created_by, :current, :division, :updated_by
  
  has_many :departments
  
  belongs_to :business
  
  validates :business_id,					presence: true
  validates :division,						presence: true, length: { maximum: 25 }, 
  																	uniqueness: { case_sensitive: false, scope: :business_id,
  				message: "Division name is a duplicate - if it's not in the current list, make sure it's not in your list of old divisions." }
  																	
  default_scope order: 'divisions.division ASC'	
  
  
  def has_departments?		
    @cnt = Department.where("division_id =?", self.id).count
    @cnt > 0
  end
  
  def has_current_departments?
  	@cnt = Department.where("division_id =? and current =?", self.id, true).count
    @cnt > 0	
  end
end												
