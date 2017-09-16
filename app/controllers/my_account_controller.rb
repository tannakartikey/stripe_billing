class MyAccountController < ApplicationController
  before_filter :authenticate, only: [:index]
  def index
    @subscription = StripeSubscription.retrieve(current_user) unless current_user.subscription_id.nil?
  end
  def destroy
    StripeSubscription.delete(current_user, true)
    respond_to do |format|
      format.html { redirect_to my_account_url, alert: 'Subscription was cancelled successfully' }
    end
  end

  def update
    @subscription = StripeSubscription.retrieve(current_user) unless current_user.subscription_id.nil?
    begin
      item_id = @subscription.items.data[0].id
      items = [{
        id: item_id,
        plan: current_user.plan.stripe_id
      }]
      @subscription.items = items
      @subscription.save
      redirect_to my_account_url, notice: "Successfully reactivated"
    rescue => error
      redirect_to my_account_url, notice: error.message
    end
  end
end
