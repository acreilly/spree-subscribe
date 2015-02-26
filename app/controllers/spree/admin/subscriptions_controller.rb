module Spree
  module Admin
    class SubscriptionsController < Spree::Admin::BaseController

      def index
        @search = Spree::Subscription.ransack(params[:q])
        @subscriptions = @search.result.includes([:user]).
        page(params[:page]).
        per(params[:per_page] || Spree::Config[:orders_per_page])
      end

      def edit
        @subscription = Spree::Subscription.find(params['id'])
      end

      def update
        @subscription = Spree::Subscription.find(params['id'])
        binding.pry
        if @subscription.update_attributes(subscription_params)
          flash[:success] = 'Subscription Updated'
          redirect_to admin_subscriptions_url
        else
          flash[:notice] = 'There was a problem updating your subscription'
          redirect_to :back
        end
      end

      def activate
        Spree::Subscription.find(params[:id]).start
        flash[:success] = 'Subscription Active'
        redirect_to edit_admin_subscription_url(params[:id])
      end

      private

      def subscription_params
        params.require(:subscription).permit(:reorder_on, :state, :times, :time_unit)
      end
    end
  end
end
