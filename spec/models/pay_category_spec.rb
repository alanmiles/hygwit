# == Schema Information
#
# Table name: pay_categories
#
#  id          :integer          not null, primary key
#  category    :string(255)
#  description :string(255)
#  on_payslip  :boolean          default(FALSE)
#  created_by  :integer          default(1)
#  checked     :boolean          default(FALSE)
#  updated_by  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  position    :integer
#

require 'spec_helper'

describe PayCategory do
  before do
    @cat = PayCategory.new(category: 'Miscellaneous', description: 'Other payments')
  end
  
  subject { @cat }

  it { should respond_to(:category) }
  it { should respond_to(:description) }
  it { should respond_to(:on_payslip) }
  it { should respond_to(:created_by) }
  it { should respond_to(:updated_by) }
  it { should respond_to(:checked) }
  it { should be_valid }
  
  describe "when 'category' is not present" do
    before { @cat.category = " " }
    it { should_not be_valid }
  end
  
  describe "when 'category' is nil" do
    before { @cat.category = nil }
    it { should_not be_valid }
  end
  
  describe "when 'category' is too long" do
    before { @cat.category = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when 'category' is a duplicate" do
    before do
      @duplicate = @cat.dup
      @duplicate.category.upcase
      @duplicate.save
    end
    it { should_not be_valid }
  end
  
  describe "when created_by is missing" do
    before { @cat.created_by = nil }
    it { should_not be_valid }
  end
  
  describe "when created_by is not an integer" do
    before { @cat.created_by = "Alan" }
    it { should_not be_valid }
  end
  
  describe "when description is left empty" do
    before { @cat.description = nil }
    it { should be_valid }
  end
  
  describe "when description is too long" do
    before { @cat.description = "a" * 255 }
    it { should_not be_valid }
  end
end
