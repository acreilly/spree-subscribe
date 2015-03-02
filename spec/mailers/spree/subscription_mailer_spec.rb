require "spec_helper"

describe Spree::SubscriptionMailer do
  let(:subscription) { FactoryGirl.create(:active_subscription) }

  context "subscription ended" do
    let(:email) { Spree::SubscriptionMailer.subscription_ended_email(subscription.id) }

    it "should sent to subscription email" do
      email.to.should == [subscription.user.email]
    end

    it "should have proper subject" do
      email.subject.should == "Subscription Ended"
    end
  end

  context "subscription ending" do
    let(:email) { Spree::SubscriptionMailer.subscription_ending_email(subscription.id) }

    it "should sent to subscription email" do
      email.to.should == [subscription.user.email]
    end

    it "should have proper subject" do
      email.subject.should == "Subscription Ending"
    end
  end
end