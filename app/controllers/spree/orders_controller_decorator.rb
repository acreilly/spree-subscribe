Spree::OrdersController.class_eval do
  after_filter :check_subscriptions, :only => [:populate]

  def update
    @order = current_order
    unless @order
      flash[:error] = Spree.t(:order_not_found)
      redirect_to root_path and return
    end

    update_subscriptions

    if @order.contents.update_cart(order_params)
      respond_with(@order) do |format|
        format.html do
          if params.has_key?(:checkout)
            @order.next if @order.cart?
            redirect_to checkout_state_path(@order.checkout_steps.first)
          else
            redirect_to cart_path
          end
        end
      end
    else
      respond_with(@order)
    end
  end

  protected

  # DD: maybe use a format close to OrderPopulator (or move to or decorate there one day)
  # +:subscriptions => { variant_id => interval_id, variant_id => interval_id }
  def check_subscriptions
    return unless params[:subscriptions] && params[:subscriptions][:active].to_s == "1"

    params[:products].each do |product_id,variant_id|
      add_subscription variant_id, params[:subscriptions][:interval_id]
    end if params[:products]
    Spree::Variant.where(id: params[:variant_id]).each do |variant_id, quantity|
      add_subscription params[:variant_id], params[:subscriptions][:interval_id]
    end if params[:variant_id]
  end


  # DD: TODO write test for this method
  def add_subscription(variant_id, interval_id)
    line_item = current_order.line_items.where(:variant_id => variant_id).first
    interval = Spree::SubscriptionInterval.find(interval_id)

    # DD: set subscribed price
    if line_item.variant.price != line_item.product.price
      line_item.price = line_item.variant.price
    end

    # DD: create subscription
    if line_item.subscription
      line_item.subscription.update_attributes :times => interval.times, :time_unit => interval.time_unit, line_item: line_item.id
    else
      line_item.subscription = Spree::Subscription.create :times => interval.times, :time_unit => interval.time_unit, line_item_id: line_item.id
    end

    line_item.save

    line_item.subscription
  end

  def update_subscriptions
    @order.line_items.each do |line_item|
      if params["subscribe_#{line_item.id}"] && line_item.subscription.blank?
        add_subscription line_item.variant_id, subscription_interval_id(line_item.variant_id)
      elsif line_item.subscription.present? && !params["subscribe_#{line_item.id}"]
        delete_subscription line_item
      end
    end
  end

  def delete_subscription(line_item)
    line_item.subscription.destroy if line_item.subscription
  end

  def subscription_interval_id(variant_id)
    @_subscriptions ||= Spree::Variant.find(variant_id).product.subscription_intervals
    return @_subscriptions.first.id unless @_subscriptions.blank?
    nil
  end
end