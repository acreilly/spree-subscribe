Spree::LineItem.class_eval do

  has_one :subscription, :foreign_key => "line_item_id", :dependent => :destroy

  accepts_nested_attributes_for :subscription
  validate :subscription_quantity

  def subscribable?
    product.subscribable
  end

  def subscription_quantity_is_one?
    if self.subscribable? && self.quantity <= 1
      true
    else
      false
    end
  end

  def subscription_quantity
    if subscribable?
      unless order.subscriptions.length <= 1 && subscription_quantity_is_one?
        errors.add(:quantity, "Only one subscription can be added to an order at a time.")
      end
    end
  end
end
