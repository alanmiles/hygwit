# == Schema Information
#
# Table name: country_admins
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  country_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe CountryAdmin do
  
  before do
    @admin = FactoryGirl.create(:admin, name: "C Admin", email: "cadmin@example.com")
    @nationality = FactoryGirl.create(:nationality, nationality: "Brazilian")
    @currency = FactoryGirl.create(:currency, currency: "Peso", code: "BRP")
    @country = FactoryGirl.create(:country, country: "Brazil", nationality_id: @nationality.id, currency_id: @currency.id)
    @co_ad = CountryAdmin.new(user_id: @admin.id, country_id: @country.id)
  end
  
  subject { @co_ad }

  it { should respond_to(:user_id) }
  it { should respond_to(:country_id) }
  it { should be_valid }
  
  describe "when user_id is not present" do
    before { @co_ad.user_id = nil }
    it { should_not be_valid }
  end
  
  describe "when country_id is not present" do
    before { @co_ad.country_id = nil }
    it { should_not be_valid }
  end
  
  describe "when user is not an admin" do
    before { @admin.toggle!(:admin) }
    it { should_not be_valid }
  end
  
  describe "when record duplicates user and country" do
    before do
      @dup = @co_ad.dup
      @dup.save
    end
    it { should_not be_valid }
  end
  
  describe "when adding a second country for a user" do
    before do
      @currency_2 = Currency.create(currency: "Pounds", code: "GBP")
      @nationality_2 = Nationality.create(nationality: "British")
      @country_2 = Country.create(country: "UK", nationality_id: @nationality_2.id, currency_id: @currency_2.id)
      @co_ad_2 = CountryAdmin.create(user_id: @admin.id, country_id: @country_2.id)
    end
    it { should be_valid }
  end
  
  describe "when adding a second admin for a country" do
    before do
      @user = FactoryGirl.create(:user, name: "Second Admin", email: "secondadmin@example.com")
      @user.toggle!(:admin)
      @co_ad_2 = CountryAdmin.create(user_id: @user.id, country_id: @country.id)
    end
    it { should be_valid }
  end
end
