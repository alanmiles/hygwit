# == Schema Information
#
# Table name: jobfamilies
#
#  id         :integer          not null, primary key
#  job_family :string(255)
#  approved   :boolean          default(FALSE)
#  created_by :integer          default(1)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  checked    :boolean          default(FALSE)
#  updated_by :integer          default(1)
#

class Jobfamily < ActiveRecord::Base

  attr_accessible :approved, :created_by, :job_family, :checked, :updated_by
  
  has_many :reserved_occupations, dependent: :destroy
  
  validates :job_family, presence: true, length: { maximum: 50 },
                     uniqueness: { case_sensitive: false }
  validates :created_by, presence: true
  
  default_scope order: 'jobfamilies.job_family ASC'
  
  def self_ref
    job_family
  end
  
  def self.non_reserved_jobs(country)
    @country = Country.find(country.id)
    if @country.reserved_occupations.count == 0
      @records = self.all
    else
      ids_to_exclude = []
      @occupations = @country.reserved_occupations
      @occupations.each do |occupation|
        ids_to_exclude << occupation.jobfamily_id
      end
      jf_table = Arel::Table.new(:jobfamilies)
      @records = self.where(jf_table[:id].not_in ids_to_exclude)
    end
    return @records
  end
  
end
