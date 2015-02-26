class Spree::SubscriptionInterval < ActiveRecord::Base
  include Spree::Concerns::Intervalable


  has_and_belongs_to_many :products, :class_name => "Spree::Product", :join_table => 'spree_subscription_intervals_products'
end
