class Spree::SubscriptionInterval < ActiveRecord::Base
  include Spree::Concerns::Intervalable
  # params_for :subscription_interval, :name


  has_and_belongs_to_many :products, :class_name => "Spree::Product", :join_table => 'spree_subscription_intervals_products'
  #has_many :subscriptions, :class_name => "Spree::Subscription", :foreign_key => 'interval_id'
end
