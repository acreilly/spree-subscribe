class Spree::SubscriptionMailer < Spree::BaseMailer

  def subscription_ending_email(subscription_id)
    @subscription = Spree::Subscription.find(subscription_id)
    @subscribed_by = @subscription.user.email
    mail(to: @subscribed_by, subject: "Subscription Ending", from: from_address)
  end

  def subscription_ended_email(subscription_id)
    @subscription = Spree::Subscription.find(subscription_id)
    @subscribed_by = @subscription.user.email
    mail(to: @subscribed_by, subject: "Subscription Ended", from: from_address)
  end
end
