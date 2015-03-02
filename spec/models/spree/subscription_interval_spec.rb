require 'spec_helper'

describe Spree::SubscriptionInterval do
  it {should have_and_belong_to_many :products}

  before(:each) do
    @interval = create(:subscription_interval)
  end

  it "has a 3 month time period" do
    @interval.time.should eq(3.months)
  end

  it "have a symbol :month for time_unit_symbol" do
    @interval.time_unit_symbol.should eq(:month)
  end

  it "have a title of '3 Months' for time_title" do
    @interval.time_title.should eq("3 Months")
  end
end
