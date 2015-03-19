class Spree::Subscription < ActiveRecord::Base
  include Spree::Concerns::Intervalable
  attr_accessor :new_order
  belongs_to :line_item, :class_name => "Spree::LineItem"
  belongs_to :billing_address, :foreign_key => :billing_address_id, :class_name => "Spree::Address"
  belongs_to :shipping_address, :foreign_key => :shipping_address_id, :class_name => "Spree::Address"
  belongs_to :shipping_method
  #belongs_to :interval, :class_name => "Spree::SubscriptionInterval"
  belongs_to :source, :polymorphic => true, :validate => true
  belongs_to :payment_method
  belongs_to :user, :class_name => Spree.user_class.to_s

  has_many :reorders, :class_name => "Spree::Order"

  scope :active, -> {where(:state => 'active')}
  scope :post_cart, -> {where("state != ?", "cart")}

  state_machine :state, :initial => :cart do
    event :suspend do
      transition :to => :inactive, :from => :active
    end
    event :start, :resume do
      transition :to => :active, :from => [:cart,:inactive]
    end
    event :cancel do
      transition :to => :canceled, :from => :active
    end

    after_transition :on => :start, :do => :set_checkout_requirements
    after_transition :on => :resume, :do => :check_reorder_date
  end

  # DD: TODO pull out into a ReorderBuilding someday
  def reorder
    if self.state == 'active' && self.reorder_on == Date.today
      create_reorder &&
      add_subscribed_line_item

      select_shipping if self.line_item.order.shipments.any?

      add_payment &&
      confirm_reorder &&
      complete_reorder &&
      calculate_reorder_date! &&
      calculate_remaining_time! &&
      check_remaining_time
      if self.remaining_time == 1
        self.notify_ending!
      end
    end
  end

  def create_reorder
    self.new_order = Spree::Order.create(
      bill_address: self.billing_address.clone,
      ship_address: self.shipping_address.clone,
      subscription_id: self.id,
      email: self.user.email
      )
    self.new_order.user_id = self.user_id

    if self.new_order.respond_to?(:store_id)
      self.new_order.store_id = self.line_item.order.store_id
    end
    # Returns true if the new order was created successfully
    self.new_order.present?
  end

  def add_subscribed_line_item
    variant = Spree::Variant.find(self.line_item.variant_id)

    line_item = self.new_order.contents.add( variant, self.line_item.quantity )
    line_item.price = self.line_item.price
    line_item.save!

    self.new_order.next # -> address
    self.new_order.next # -> delivery
  end

  def select_shipping
    # DD: shipments are created when order state goes to "delivery"
    shipment = self.new_order.shipments.first # DD: there should be only one shipment
    rate = shipment.shipping_rates.first{|r| r.shipping_method.id == reorder_shipping_method.id }
    raise "No rate was found. TODO: Implement logic to select the cheapest rate." unless rate
    shipment.selected_shipping_rate_id = rate.id
    shipment.save
  end

  def add_payment
    payment = self.new_order.payments.build( :amount => self.new_order.item_total )
    payment.source = self.source
    payment.payment_method = self.payment_method
    payment.save!

    self.new_order.next # -> payment
  end

  def confirm_reorder
    self.new_order.next # -> confirm
  end

  def complete_reorder
    self.new_order.update!
    self.new_order.next && self.new_order.save # -> complete
  end

  def calculate_reorder_date!
    self.reorder_on ||= Date.today
    self.reorder_on += self.time
    save
  end

  def calculate_remaining_time!
    if self.remaining_time.nil?
      result = get_remaining_time
      unless self.reorder_on.nil?
        result -= 1
      end
      self.remaining_time = result
    elsif self.remaining_time <= 0
      self.remaining_time = 0
    else
      self.remaining_time -= 1
    end
    save
  end

  def get_remaining_time
    case self.time_unit_length_symbol
    when :year
      case self.time_unit_symbol
      when :year
        result = 1 / self.times * self.time_length
      when :month
        result = 12 / self.times * self.time_length
      when :week
        result = 52 / self.times * self.time_length
      when :day
        if Date.today.leap?
          result = 366 / self.times * self.time_length
        else
          result = 365 / self.times * self.time_length
        end
      end
    when :month
      case self.time_unit_symbol
      when :month
        result = self.times * self.time_length
      when :week
        result = 4 / self.times * self.times_length
      when :day
        result = Time.now.end_of_month.day / self.times * self.times_length
      end
    when :week
      case self.time_unit_symbol
      when :week
        result = self.times * self.times_length
      when :day
        result = 7 / self.times * self.times_length
      end
    when :day
      case self.time_unit_symbol
      when :day
        result = self.times * self.times_length
      end
    end
    return result
  end

  def check_remaining_time
    if self.remaining_time <= 0
      self.remaining_time = nil
      self.reorder_on = nil
      self.suspend
      self.notify_ended!
    end
  end

  def notify_ended!
    Spree::SubscriptionMailer.subscription_ended_email(self.id).deliver
  end

  def notify_ending!
    Spree::SubscriptionMailer.subscription_ending_email(self.id).deliver
  end

  private

  # DD: if resuming an old subscription
  def check_reorder_date
    if reorder_on.nil? || reorder_on <= Date.today
      reorder_on = Date.tomorrow
      save
    end
  end

  # DD: assumes interval attributes come in when created/updated in cart
  def set_checkout_requirements
    order = self.line_item.order
    # DD: TODO: set quantity?
    calculate_reorder_date!
    calculate_remaining_time!
    shipping_method_id = order.shipping_method_for_variant( self.line_item.variant ).try(:id) || Spree::ShippingMethod.find_by_name("Not Shippable").id

    update_attributes(
      :billing_address_id => order.bill_address_id,
      :shipping_address_id => order.ship_address_id || order.bill_address_id,
      :shipping_method_id => shipping_method_id,
      :payment_method_id => order.payments.first.payment_method_id,
      :source_id => order.payments.first.source_id,
      :source_type => order.payments.first.source_type,
      :user_id => order.user_id,
      line_item: self.line_item
      )
  end

  def self.reorder_states
    @reorder_states ||= state_machine.states.map(&:name) - ["cart"]
  end

  def reorder_shipping_method
    reorder_shipping_method = Spree::ShippingMethod.find_by_name(:name => "Economy (5-10 Business Days - $0.00)")
  end

end
