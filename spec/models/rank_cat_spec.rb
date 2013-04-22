# == Schema Information
#
# Table name: rank_cats
#
#  id          :integer          not null, primary key
#  business_id :integer
#  rank        :string(255)
#  position    :integer
#  created_by  :integer
#  updated_by  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe RankCat do
  before do
    @country = FactoryGirl.create(:country, created_by: 1, complete: true)
    @rank = FactoryGirl.create(:rank, created_by: 1, checked: true)
    @business = FactoryGirl.create(:business, country_id: @country.id, created_by: 1)
    @rank_cat = @business.rank_cats.build(rank: "Support")
  end
  
  subject { @rank_cat }

  it { should respond_to(:rank) }
  it { should respond_to(:business_id) }
  its(:business) { should == @business }
  it { should respond_to(:position) }
  it { should respond_to(:created_by) }
  it { should respond_to(:updated_by) }
  
  it { should be_valid }
  
  describe "accessible attributes" do
    it "should not allow access to business_id" do
      expect do
        RankCat.new(business_id: @business.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end
  
  describe "when business_id is nil" do
    before { @rank_cat.business_id = nil }
    it { should_not be_valid }
  end
  
  describe "when rank is not present" do
    before { @rank_cat.rank = " " }
    it { should_not be_valid }
  end
  
  describe "when rank is nil" do
    before { @rank_cat.rank = nil }
    it { should_not be_valid }
  end
  
  describe "when rank is too long" do
    before { @rank_cat.rank = "a" * 26 }
    it { should_not be_valid }
  end
  
  describe "when rank is a duplicate for the same business" do
    before do
      @duplicate = @rank_cat.dup
      @duplicate.rank.upcase
      @duplicate.save
    end
    it { should_not be_valid }
  end
  
  describe "when rank is a duplicate but for a different business" do
    before do
      @business_2 = @business.dup
      @business_2.name = "Business Foo"
      @business_2.save
      @non_duplicate = @rank_cat.dup
      @non_duplicate.business_id = @business_2.id
      @non_duplicate.save
    end
    it { should be_valid }
  end
end
