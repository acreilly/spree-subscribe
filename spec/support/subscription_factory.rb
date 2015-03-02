FactoryGirl.define do
  factory :cart_subscription, :class => Spree::Subscription do
    times 3
    time_unit 3  # DD: 3 = months
    time_length 1  # DD: 3 = months
    time_unit_length 4  # DD: 3 = months
    line_item { create(:line_item_with_completed_order) }
    # DD: don't put user association here (copied from Spree::Order when activated)
  end
  factory :active_subscription, :class => Spree::Subscription do
    times 3
    time_unit 3  # DD: 3 = months
    time_length 1  # DD: 3 = months
    time_unit_length 4  # DD: 3 = months
    remaining_time 11  # DD: 3 = months
    line_item { create(:line_item_with_completed_order) }
    user { create(:user) }
    # DD: don't put user association here (copied from Spree::Order when activated)
  end

  factory :subscription_for_reorder, :parent => :active_subscription do
    # DD: needs a completed order
    reorder_on Date.today
  end
end