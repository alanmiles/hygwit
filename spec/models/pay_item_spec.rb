# == Schema Information
#
# Table name: pay_items
#
#  id              :integer          not null, primary key
#  item            :string(255)
#  pay_category_id :integer
#  short_name      :string(255)
#  deduction       :boolean          default(FALSE)
#  taxable         :boolean          default(FALSE)
#  fixed           :boolean          default(FALSE)
#  position        :integer
#  created_by      :integer          default(1)
#  checked         :boolean          default(FALSE)
#  updated_by      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe PayItem do
  before do
    @cat = PayCategory.create(category: 'BarBaz', description: 'Foobar')
    @item = PayItem.new(item: 'Housing benefit', pay_category_id: @cat.id, short_name: 'House A')
  end
  
  subject { @item }

  it { should respond_to(:item) }
  it { should respond_to(:pay_category_id) }
  it { should respond_to(:short_name) }
  it { should respond_to(:deduction) }
  it { should respond_to(:taxable) }
  it { should respond_to(:fixed) }
  it { should respond_to(:position) }
  it { should respond_to(:created_by) }
  it { should respond_to(:updated_by) }
  it { should respond_to(:checked) }
  it { should be_valid }
  
  describe "when 'item' is not present" do
    before { @item.item = " " }
    it { should_not be_valid }
  end
  
  describe "when 'item' is nil" do
    before { @item.item = nil }
    it { should_not be_valid }
  end
  
  describe "when 'item' is too long" do
    before { @item.item = "a" * 36 }
    it { should_not be_valid }
  end
  
  describe "when 'item' is a duplicate" do
    before do
      @duplicate = @item.dup
      @duplicate.item.upcase
      @duplicate.save
    end
    it { should_not be_valid }
  end
  
  describe "when 'pay_category_id' is nil" do
    before { @item.pay_category_id = nil }
    it { should_not be_valid }
  end
  
  describe "when 'short_name' is not present" do
    before { @item.short_name = " " }
    it { should_not be_valid }
  end
  
  describe "when 'short_name' is nil" do
    before { @item.short_name = nil }
    it { should_not be_valid }
  end
  
  describe "when 'short_name' is too long" do
    before { @item.short_name = "a" * 11 }
    it { should_not be_valid }
  end
  
  describe "when 'short_name' is a duplicate" do
    before do
      @duplicate = @item.dup
      @duplicate.short_name.upcase
      @duplicate.save
    end
    it { should_not be_valid }
  end
  
  describe "when created_by is missing" do
    before { @item.created_by = nil }
    it { should_not be_valid }
  end
  
  describe "when created_by is not an integer" do
    before { @item.created_by = "Alan" }
    it { should_not be_valid }
  end
end
