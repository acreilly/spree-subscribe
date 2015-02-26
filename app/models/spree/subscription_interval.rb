class Spree::SubscriptionInterval < ActiveRecord::Base
  include Spree::Concerns::Intervalable
  before_save :check_time_units

  has_and_belongs_to_many :products, :class_name => "Spree::Product", :join_table => 'spree_subscription_intervals_products'



  def check_time_units
    if self.time_unit > self.time_unit_length
      self.errors.add(:time_unit_length,'Needs to be greater than or equal to reorder interval')
      false
    end
  end
end
