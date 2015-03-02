class Spree::SubscriptionsController < Spree::StoreController
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  load_and_authorize_resource :class => Spree::Subscription

  def destroy
    @subscription.active? ? @subscription.suspend : @subscription.resume

    redirect_to account_url
  end

  def update
    if !@subscription.active?
      @subscription.start
      @subscription.reorder
    else
      @subscription.update_attributes(remaining_time: @subscription.remaining_time + @subscription.get_remaining_time)
    end
    redirect_to account_url
  end
end
