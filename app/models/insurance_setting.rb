# == Schema Information
#
# Table name: insurance_settings
#
#  id                  :integer          not null, primary key
#  country_id          :integer
#  shortcode           :string(255)
#  name                :string(255)
#  weekly_milestone    :decimal(, )
#  monthly_milestone   :decimal(, )
#  annual_milestone    :decimal(, )
#  effective_date      :date
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  cancellation_date   :date
#  checked             :boolean          default(FALSE)
#  updated_by          :integer          default(1)
#  created_by          :integer          default(1)
#  cancellation_change :boolean          default(FALSE)
#

class InsuranceSetting < ActiveRecord::Base

  attr_accessible :annual_milestone, :effective_date, :monthly_milestone, :name, :shortcode, :weekly_milestone, :cancellation_date,
      :checked, :updated_by, :created_by, :cancellation_change
  
  before_destroy :remove_associated_rates
  
  belongs_to :country
  has_many :thresholds, class_name: InsuranceRate, foreign_key: :threshold_id
  has_many :ceilings, class_name: InsuranceRate, foreign_key: :ceiling_id
  
  before_save	:upcase_shortcode
  
    
  validates :country_id,					presence: true
  validates :shortcode,						presence: true, length: { maximum: 5 }, uniqueness: { scope: [:country_id, :effective_date] }
  validates :name,								presence: true, length: { maximum: 30 }, uniqueness: { scope: [:country_id, :effective_date] }
  validates :weekly_milestone,		presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :monthly_milestone,		presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :annual_milestone,		presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :effective_date,			presence: true
  validates :created_by,					presence: true
  validate  :early_cancellation_date
  validate  :cancellation_with_future_record, on: :update
  validate  :duplicate_cancelled, on: :create
  
  def self.future_settings?
    cnt = InsuranceSetting.where("effective_date >?", Date.today).count
    cnt > 0
  end
  
  def self.current_list
    rows = InsuranceSetting.where("effective_date <=? AND 
       (cancellation_date IS NULL OR cancellation_date >?)", Date.today, Date.today)
       .select("shortcode, max(effective_date) AS effective_date, max(monthly_milestone) AS monthly_milestone")
       .group("shortcode")
       .order("3 ASC")
    @settings = []
    rows.each do |r|
      @settings << InsuranceSetting.find_by_shortcode_and_effective_date(r.shortcode, r.effective_date)
    end
    return @settings
  end
  
  def self.records_exist?
    @nmbr = self.current_list.count
    @nmbr > 0
  end
  
  def self.first_on_current_list
    self.current_list.first
  end
  
  def self.snapshot_list(stated_date)
    rows = InsuranceSetting.where("date(effective_date) <=? AND 
       (cancellation_date IS NULL OR date(cancellation_date) >?)", stated_date, stated_date)
       .select("shortcode, max(effective_date) AS effective_date, max(monthly_milestone) AS monthly_milestone")
       .group("shortcode")
       .order("3 ASC")
    @settings = []
    rows.each do |r|
      @settings << InsuranceSetting.find_by_shortcode_and_effective_date(r.shortcode, r.effective_date)
    end
    return @settings
  end
  
  def self.auto_ceiling(date, threshold)
    @ceiling = nil
    @threshold = self.find(threshold)
    unless @threshold.nil?
      @country = Country.find(@threshold.country_id)
      @settings = @country.insurance_settings.snapshot_list(date)
      @shortcodes = []
      @settings.each do |setting|
        @shortcodes << setting.shortcode
      end
      total = @shortcodes.count
      @threshold_index = @shortcodes.index(@threshold.shortcode)
      if @threshold_index == total - 1
        @ceiling = nil
      elsif @threshold_index.nil?
        @ceiling = nil
      else
        @ceiling = @settings.fetch(@threshold_index + 1).id
      end
    end
    return @ceiling
  end
  
  def self.future_list
    rows = InsuranceSetting.where("effective_date >?", Date.today).order("effective_date DESC, monthly_milestone")
    #   .select("shortcode, max(effective_date) AS effective_date, max(monthly_milestone) AS monthly_milestone")
    #   .group("shortcode")
    #   .order("2 DESC, 3 ASC")
    @settings = []
    rows.each do |r|
      @settings << InsuranceSetting.find_by_shortcode_and_effective_date(r.shortcode, r.effective_date)
    end
    return @settings
  end
  
  def self.current_and_future_list
    @list = self.current_list
    self.future_list.each do |r|
      @list << r
    end
    @list.sort_by(&:monthly_milestone)   
  end
  
  def in_current_list
    @country = Country.find(self.country_id)
    @recs = @country.insurance_settings.current_list
    @found = false
    @recs.each do |r|
      @found = true if r.id == id
    end
    return @found
  end
  
  def in_future_list
    @found = false
    @country = Country.find(self.country_id)
    if @country.insurance_settings.future_list.count > 0
      @recs = @country.insurance_settings.future_list
      @recs.each do |r|
        @found = true if r.id == id
      end
    end
    return @found
  end
  
  def previous_cancellation
    result = false 
    if cancellation_date? && effective_date < Date.today
      result = true
    end
    return result   
  end
  
  def last_cancelled
    if cancellation_date?
      @country = Country.find(country_id)
      cancellations = @country.insurance_settings
           .where("cancellation_date IS NOT NULL AND shortcode =?", shortcode)
           .order("effective_date DESC")
      @first_rec = cancellations.first
      if self.id == @first_rec.id
        return true
      else
        return false
      end
    else
      return false
    end
  end
  
  def threshold_details
    @country = Country.find(country_id)
    @details = "#{shortcode} ( >#{@country.currency.code} #{sprintf("%.0d", monthly_milestone)}, effective #{effective_date.strftime("%d-%b-%y")} )"
  end
  
  def ceiling_details
    @country = Country.find(country_id)
    @details = "#{shortcode} ( #{@country.currency.code} #{sprintf("%.0d", monthly_milestone)}, effective #{effective_date.strftime("%d-%b-%y")} )"
  end
  
  def self.duplicate_exists?(code, date)
    @record_count = self.where("shortcode = ? AND effective_date =?", code, date).count
    @record_count > 0
  end
  
  def self.cancel_status_all(ref)
    @record = self.find_by_id(ref)
    @country = Country.find(@record.country_id)
    @entries = @country.insurance_settings.where("shortcode =?", @record.shortcode)
    @entries.each do |entry|
      entry.update_attributes(cancellation_date: @record.cancellation_date) unless entry.id == ref
    end
  end
  
  private
  
    def upcase_shortcode
      shortcode.upcase!
    end
  
    def early_cancellation_date
      unless effective_date.nil? || cancellation_date.nil?
        if cancellation_date <= effective_date
          errors[:base] << "The cancellation date must be after the effective date."
        end
      end
    end
    
    def cancellation_with_future_record
      if cancellation_date?
        @country = Country.find(country_id)
        @code = shortcode
        @cnt = @country.insurance_settings.where("shortcode = ? and effective_date >?", @code, Date.today).count
        if @cnt > 0     
          errors[:base] << "You're trying to cancel the code '#{@code}' but you've already defined new settings for a
            future date.  Remove the cancellation date, then go to the 'Future settings' list, and delete the 
            '#{@code}' entry there.  When you've done that, try again."
        end
      end
    end
    
    def duplicate_cancelled
      @country = Country.find(self.country_id)
      @code = shortcode
      @cnt = @country.insurance_settings.where("shortcode = ? and cancellation_date IS NOT NULL", @code).count
      if @cnt > 0
        errors[:base] << "This code has been cancelled, so should not be used in #{@country.country}.  You'll find more
           details in the Salary Thresholds History.  Either remove the cancellation, or use a different code."
      end 
    end
    
    def remove_associated_rates
      @country = Country.find(country_id)
      @thresholds = @country.insurance_rates.where("threshold_id =?", self.id)
      @thresholds.each do |threshold|
        threshold.destroy
      end
      @ceilings = @country.insurance_rates.where("ceiling_id =?", self.id)
      @ceilings.each do |ceiling|
        ceiling.destroy
      end  
    end
end 
