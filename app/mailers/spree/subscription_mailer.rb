class Spree::SubscriptionMailer < Spree::BaseMailer

  def subscription_ending_email(subscription_name, email)
    @subscription = subscription_name
    @subscribed_by = email
    mail(to: @subscribed_by, subject: "Subscription Ending", from: from_address)
  end

  def subscription_ended_email(subscription_name, email)
    @subscription = subscription_name
    @subscribed_by = email
    mail(to: @subscribed_by, subject: "Subscription Ended", from: from_address)
  end
end
