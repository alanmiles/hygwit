# == Schema Information
#
# Table name: qualities
#
#  id         :integer          not null, primary key
#  quality    :string(255)
#  approved   :boolean          default(FALSE)
#  created_by :integer          default(1)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  checked    :boolean          default(FALSE)
#  updated_by :integer          default(1)
#

require 'spec_helper'

describe Quality do
  
  before do
    @quality = Quality.new(quality: 'Punctuality', created_by: 1)
  end
  
  subject { @quality }

  it { should respond_to(:quality) }
  it { should respond_to(:approved) }
  it { should respond_to(:created_by) }
  it { should respond_to(:descriptors) }
  it { should respond_to(:checked) }
  it { should respond_to(:created_at) }
  
  it { should be_valid }
  
  describe "when quality is not present" do
    before { @quality.quality = " " }
    it { should_not be_valid }
  end
  
  describe "when quality is nil" do
    before { @quality.quality = nil }
    it { should_not be_valid }
  end
  
  describe "when quality is too long" do
    before { @quality.quality = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when quality is a duplicate" do
    before do
      @duplicate = @quality.dup
      @duplicate.quality.upcase
      @duplicate.save
    end
    it { should_not be_valid }
  end
  
  describe "when 'created_by' is missing" do
    before { @quality.created_by = nil }
    it { should_not be_valid }
  end
  
end
