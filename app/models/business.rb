# == Schema Information
#
# Table name: businesses
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  country_id            :integer
#  address_1             :string(255)
#  address_2             :string(255)
#  city                  :string(255)
#  sector_id             :integer
#  created_by            :integer
#  updated_by            :integer
#  registration_number   :string(255)
#  bank                  :string(255)      default("(Name of your payroll bank)")
#  bank_branch           :string(255)      default("(Branch identifier)")
#  iban                  :string(255)      default("(Business iban code)")
#  calendar_days         :boolean          default(TRUE)
#  hours_per_day         :decimal(4, 2)    default(8.0)
#  hours_per_month       :decimal(5, 2)    default(160.0)
#  weekend_day_1         :integer          default(6)
#  weekend_day_2         :integer          default(7)
#  standard_ot_rate      :decimal(3, 2)    default(1.25)
#  supplementary_ot_rate :decimal(3, 2)    default(1.5)
#  double_ot_rate        :decimal(3, 2)    default(2.0)
#  standard_start_time   :string(255)      default("08:00")
#  autocalc_benefits     :boolean          default(FALSE)
#  pension_scheme        :boolean          default(FALSE)
#  bonus_provision       :boolean          default(FALSE)
#  close_date            :integer          default(15)
#  last_payroll_date     :date
#  home_airport          :string(255)
#  review_interval       :integer          default(6)
#  setup_complete        :boolean          default(FALSE)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class Business < ActiveRecord::Base
  
  attr_accessible :address_1, :address_2, :autocalc_benefits, :bank, :bank_branch, :bonus_provision, :calendar_days, 
                  :city, :close_date, :country_id, :created_by, :double_ot_rate, :home_airport, :hours_per_day, 
                  :hours_per_month, :iban, :last_payroll_date, :name, :pension_scheme, :registration_number, :review_interval, 
                  :sector_id, :setup_complete, :standard_ot_rate, :standard_start_time, :supplementary_ot_rate, :updated_by, 
                  :weekend_day_1, :weekend_day_2
                  
  belongs_to :country
  belongs_to :sector
  has_many :business_admins, dependent: :destroy
  has_many :absence_cats, dependent: :destroy
  has_many :leaving_cats, dependent: :destroy
  has_many :disciplinary_cats, dependent: :destroy
  has_many :grievance_cats, dependent: :destroy
  has_many :contract_cats, dependent: :destroy
  has_many :rank_cats, dependent: :destroy
  has_many :joiner_activities, dependent: :destroy
  has_many :leaver_activities, dependent: :destroy
  has_many :payroll_cats, dependent: :destroy
  has_many :payroll_items, dependent: :destroy
  has_many :loan_cats, dependent: :destroy
  has_many :advance_cats, dependent: :destroy
  has_many :personal_qualities, dependent: :destroy
  has_many :divisions, dependent: :destroy
  has_many :departments, dependent: :destroy
  has_many :jobs, through: :departments
  
  
  #belongs_to :weekday
  
  after_create :add_associated
  
  validates :name, 											presence: true, length: { maximum: 50 },
                     										uniqueness: { case_sensitive: false, scope: :country_id }
  validates :country_id, 								presence: true
  validates :sector_id,									presence: true
  validates :address_1,									length: { maximum: 100, allow_blank: true }
  validates :address_2,									length: { maximum: 100, allow_blank: true }
  validates :city,											length: { maximum: 35, allow_blank: true }
  validates :created_by,								presence: true, numericality: { only_integer: true }
  validates :hours_per_day,							presence: true, numericality: true, inclusion: { in: 1..13 }
  validates :hours_per_month,						presence: true, numericality: true, inclusion: { in: 5..240 }
  validates	:weekend_day_1,							presence: true, numericality: { only_integer: true }, inclusion: { in: 1..7 }
  validates	:weekend_day_2,							presence: true, numericality: { only_integer: true, allow_zero: true }, inclusion: { in: 0..7 }
  validates :registration_number,				length: { maximum: 20, allow_blank: true }
  validates :bank, 											presence: true, length: { maximum: 50 }
  validates :bank_branch, 							presence: true, length: { maximum: 50 }
  validates :iban,				 							presence: true, length: { maximum: 25 }
  validates :standard_ot_rate,					presence: true, numericality: true, inclusion: { in: 0..2 }
  validates :supplementary_ot_rate,			presence: true, numericality: true, inclusion: { in: 0..2 }
  validates :double_ot_rate,					  presence: true, numericality: true, inclusion: { in: 0..3 }
  VALID_STARTTIME_REGEX = /^(20|21|22|23|[01]\d|\d)(([:][0-5]\d){1,2})$/
  validates :standard_start_time,				presence: true, format: { with: VALID_STARTTIME_REGEX }
  validates :close_date,								presence: true, numericality: { only_integer: true }, inclusion: { in: 10..27 }
  validates :home_airport, 							length: { maximum: 35, allow_blank: true }
  validates :review_interval,						presence: true, numericality: { only_integer: true }, inclusion: { in: 1..12 }
  
  default_scope order: 'businesses.name ASC'
  
  def current_divisions
    Division.where("business_id =? and current =?", self.id, true)
  end
  
  def former_divisions
    Division.where("business_id =? and current =?", self.id, false)
  end
  
  def has_former_divisions?
    @div_count = Division.where("business_id =? and current =?", self.id, false).count
    @div_count > 0
  end
  
  private
  
    def add_associated
      add_absence_cats
      add_leaving_cats
      add_disciplinary_cats
      add_grievance_cats
      add_contract_cats
      add_rank_cats
      add_joiner_activities
      add_leaver_activities
      add_payroll_cats
      add_payroll_items
      add_loan_cats
      add_advance_cats
      add_personal_qualities
    end
  
    def add_absence_cats
      @country = Country.find(self.country_id)
      @absences = @country.checked_absences
      @absences.each do |absence|
        self.absence_cats.create(absence_code: absence.absence_code, paid: absence.paid, sickness: absence.sickness,
                                    maximum_days_year: absence.maximum_days_year, 
                                    documentation_required: absence.documentation_required, notes: absence.notes)  
      end         
    end
    
    def add_leaving_cats
      @leave_reasons = LeavingReason.all_checked
      @leave_reasons.each do |reason|
        self.leaving_cats.create(reason: reason.reason, full_benefits: reason.full_benefits)
      end
    end    
    
    def add_disciplinary_cats
      @disc_categories = DisciplinaryCategory.all_checked
      @disc_categories.each do |category|
        self.disciplinary_cats.create(category: category.category)
      end
    end
    
    def add_grievance_cats
      @grievances = GrievanceType.all_checked
      @grievances.each do |grievance|
        self.grievance_cats.create(grievance: grievance.grievance)
      end
    end
    
    def add_contract_cats
      @contracts = Contract.all_checked
      @contracts.each do |contract|
        self.contract_cats.create(contract: contract.contract)
      end
    end
    
    def add_rank_cats
      @ranks = Rank.all_checked
      @ranks.each do |rank|
        self.rank_cats.create(rank: rank.rank, position: rank.position)
      end
    end
    
    def add_joiner_activities
      @actions = JoinerAction.all_checked
      @actions.each do |action|
        self.joiner_activities.create(action: action.action, position: action.position, contract: action.contract,
        				residence: action.residence, nationality: action.nationality, marital_status: action.marital_status)
      end
    end
    
    def add_leaver_activities
      @actions = LeaverAction.all_checked
      @actions.each do |action|
        self.leaver_activities.create(action: action.action, position: action.position, contract: action.contract,
        				residence: action.residence, nationality: action.nationality, marital_status: action.marital_status)
      end
    end
    
    def add_payroll_cats
      @paycats = PayCategory.all_checked
      @paycats.each do |paycat|
        self.payroll_cats.create(category: paycat.category, description: paycat.description, position: paycat.position,
        				on_payslip: paycat.on_payslip)
      end
    end
    
    def add_payroll_items
      @payitems = PayItem.all_checked
      @payitems.each do |payitem|
        @cat_name = payitem.pay_category.category
        @new_cat = PayrollCat.find_by_business_id_and_category(self.id, @cat_name)
        self.payroll_items.create(item: payitem.item, payroll_cat_id: @new_cat.id, short_name: payitem.short_name, 
        				deduction: payitem.deduction, gross_salary: payitem.taxable, fixed: payitem.fixed, position: payitem.position)
      end
    end
    
    def add_loan_cats
      @loans = LoanType.all_checked
      @loans.each do |loan|
        self.loan_cats.create(name: loan.name, qualifying_months: loan.qualifying_months, 
        				max_repayment_months: loan.max_repayment_months, max_salary_multiplier: loan.max_salary_multiplier,
        				max_amount: loan.max_amount, apr: loan.apr)
      end
    end
    
    def add_advance_cats
      @advances = AdvanceType.all_checked
      @advances.each do |advance|
        self.advance_cats.create(name: advance.name)
      end
    end
    
    def add_personal_qualities
      @qualities = Quality.all_checked
      @qualities.each do |quality|
        self.personal_qualities.create(quality: quality.quality)
        @pq = PersonalQuality.find_by_business_id_and_quality(self.id, quality.quality)
        @descriptors = quality.descriptors
        @descriptors.each do |descriptor|
          @qd = QualityDescriptor.find_by_personal_quality_id_and_grade(@pq.id, descriptor.grade)
          @qd.update_attributes(descriptor: descriptor.descriptor)
        end    
   		end
    end 
end
