# == Schema Information
#
# Table name: disciplinary_categories
#
#  id         :integer          not null, primary key
#  category   :string(255)
#  created_by :integer          default(1)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  checked    :boolean          default(FALSE)
#  updated_by :integer          default(1)
#

require 'spec_helper'

describe DisciplinaryCategory do
  
  before do
    @disciplinary_cat = DisciplinaryCategory.new(category: 'Damaging company equipment')
  end
  
  subject { @disciplinary_cat }

  it { should respond_to(:category) }
  it { should respond_to(:updated_by) }
  it { should respond_to(:checked) }
  it { should be_valid }
  
  describe "when category is not present" do
    before { @disciplinary_cat.category = " " }
    it { should_not be_valid }
  end
  
  describe "when category is nil" do
    before { @disciplinary_cat.category = nil }
    it { should_not be_valid }
  end
  
  describe "when category is too long" do
    before { @disciplinary_cat.category = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when category is a duplicate" do
    before do
      @duplicate = @disciplinary_cat.dup
      @duplicate.category.upcase
      @duplicate.save
    end
    it { should_not be_valid }
  end
  
end
