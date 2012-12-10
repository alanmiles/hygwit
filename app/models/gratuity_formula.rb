# == Schema Information
#
# Table name: gratuity_formulas
#
#  id                     :integer          not null, primary key
#  country_id             :integer
#  service_years_from     :integer
#  service_years_to       :integer
#  termination_percentage :decimal(5, 2)
#  resignation_percentage :decimal(5, 2)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  checked                :boolean          default(FALSE)
#  updated_by             :integer          default(1)
#  created_by             :integer          default(1)
#

class GratuityFormula < ActiveRecord::Base

  attr_accessible :resignation_percentage, :service_years_from, :service_years_to, :termination_percentage, :checked, :updated_by,
  								:created_by
  
  belongs_to :country
  
  validates :country_id,								presence: true
  validates :service_years_from,				presence: true, numericality: { only_integer: true }, inclusion: { in: 0..100 },
  																			uniqueness: { scope: :country_id }
  validates :service_years_to,					presence: true, numericality: { only_integer: true }, inclusion: { in: 0..100 },
  																			uniqueness: { scope: :country_id }
  validates :termination_percentage,		presence: true, numericality: true, inclusion: { in: 0..100 }
  validates :resignation_percentage,		presence: true, numericality: true, inclusion: { in: 0..100 }
  validate  :create_overlapping, on: :create
  validate  :update_overlapping, on: :update
  validate  :negative_service_years
  validates	:created_by,								presence: true

  default_scope order: 'gratuity_formulas.service_years_from ASC'
  
  
  private
    def create_overlapping
      unless GratuityFormula.where(
          'country_id = ? AND((service_years_from < ? AND service_years_to > ?) OR (service_years_from > ? AND service_years_from < ?))',
          country_id,
          service_years_from, service_years_from,
          service_years_from, service_years_to
          ).empty?
        errors[:base] << 'The service years entered overlap with another line in the table'
      end
    end
      
    def update_overlapping  
      unless GratuityFormula.where(
          'id != ? AND country_id = ? AND((service_years_from < ? AND service_years_to > ?) 
              OR (service_years_from > ? AND service_years_from < ?))',
          self.id, country_id,
          service_years_from, service_years_from,
          service_years_from, service_years_to
          ).empty?
        errors[:base] << 'The service years entered overlap with another line in the table'
      end       
    end
    
    def negative_service_years
      unless service_years_from.nil? || service_years_to.nil?
        if service_years_to <= service_years_from
          errors[:base] << "The end of the service period must be greater than the beginning of the service period."
        end
      end
    end

end
