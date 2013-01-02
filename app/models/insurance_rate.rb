# == Schema Information
#
# Table name: insurance_rates
#
#  id                :integer          not null, primary key
#  country_id        :integer
#  insurance_code_id :integer
#  source_employee   :boolean          default(TRUE)
#  threshold_id      :integer
#  ceiling_id        :integer
#  contribution      :decimal(, )
#  percent           :boolean          default(TRUE)
#  rebate            :boolean          default(FALSE)
#  created_by        :integer          default(1)
#  updated_by        :integer          default(1)
#  checked           :boolean          default(FALSE)
#  effective         :date
#  cancellation      :date
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class InsuranceRate < ActiveRecord::Base
  attr_accessible :ceiling_id, :contribution, :insurance_code_id, :percent, :rebate, :source_employee, :threshold_id,
                  :created_by, :updated_by, :checked, :effective, :cancellation
                  
  belongs_to :country
  belongs_to :insurance_code
  belongs_to :threshold, class_name: InsuranceSetting, foreign_key: :threshold_id
  belongs_to :ceiling, class_name: InsuranceSetting, foreign_key: :ceiling_id
  
  #default_scope includes(:insurance_code).order("insurance_rates.source_employee DESC, 
  #   insurance_codes.insurance_code ASC, insurance_rates.threshold_id ASC")
  
  validates  :country_id,						presence: 		true
  validates  :insurance_code_id,		presence: 		true, 
  																					uniqueness: { scope: [:country_id, :threshold_id, :source_employee, :rebate, :effective] }
  validates  :contribution,					presence:			true, numericality: true
  validates  :created_by,						presence:			true, numericality: { only_integer: true }
  validates  :threshold_id,					presence:			true
  validates	 :effective,						presence: 		true
  validate	 :ceiling_higher
  validate	 :duplicate_settings
  
  def self_ref
    insurance_rate
  end
  
  def self.future_rates?
    cnt = InsuranceRate.where("effective >? and source_employee = ?", Date.today, true).count
    cnt > 0
  end
  
  def self.future_rates_employer?
    cnt = InsuranceRate.where("effective >? and source_employee = ?", Date.today, false).count
    cnt > 0
  end
  
  def self.current_list(country, selection)
    @irates = []
    @cntry = Country.find(country)
    @icodes = @cntry.insurance_codes.on_current_list
    @isettings = @cntry.insurance_settings.current_list
    @icodes.each do |icode|
      @isettings.each do |isetting|
        @rows = selection.where("insurance_code_id =? and threshold_id =? and date(effective) <=?", icode.id, isetting.id, Date.today)
           .select("insurance_code_id, threshold_id, rebate, max(effective) AS effective")
           .group("insurance_code_id, threshold_id, rebate")
        @rows.each do |r|
          @irates << selection.find_by_insurance_code_id_and_threshold_id_and_effective(r.insurance_code_id, r.threshold_id, r.effective)
        end
      end
    end  
    return @irates  
  end
  
  
  def in_active_list
    @country = Country.find(self.country_id)
    @recs = InsuranceRate.current_list(@country, @country.insurance_rates)
    @found = false
    @recs.each do |r|
      @found = true if r.id == id
    end
    return @found
  end  
    
  def self.future_list(selection)
    @irates = selection.includes(:insurance_code, :threshold)
      .where("effective >= ? AND (insurance_codes.cancelled IS NULL OR insurance_codes.cancelled > effective)", Date.today)
      .order("insurance_codes.insurance_code ASC, insurance_settings.monthly_milestone ASC")
  end
  
  def self.history_list(selection)
    @irates = selection.includes(:insurance_code, :threshold)
      .order("insurance_codes.insurance_code ASC, insurance_settings.monthly_milestone ASC, insurance_rates.effective ASC")
  end
  
  private
  
    def ceiling_higher
      unless ceiling_id.nil? || threshold_id.nil?
        ceiling_value = ceiling.monthly_milestone
        threshold_value = threshold.monthly_milestone
        unless ceiling_value > threshold_value
          errors[:base] << 'The ceiling value must be higher than the threshold value.'
        end
      end
    end
    
    def duplicate_settings
      unless ceiling_id.nil? || threshold_id.nil?
        threshold_label = threshold.shortcode
        ceiling_label = ceiling.shortcode
        if threshold_label == ceiling_label
          errors[:base] << "You can't use the same code for both the threshold and the ceiling."
        end
      end
    end
end
