FactoryGirl.define do
  factory :subscription_interval, :class => Spree::SubscriptionInterval do
    name "3 Months"
    times 3
    time_unit 3  # DD: 3 = months
    time_length 1  # DD: 3 = months
    time_unit_length 4  # DD: 3 = months
  end
end