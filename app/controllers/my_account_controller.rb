class MyAccountController < ApplicationController
  before_filter :authenticate, only: [:index]
  def index
    @subscription = StripeSubscription.retrieve(current_user) unless current_user.subscription_id.nil?
  end
  def destroy
    StripeSubscription.delete(current_user)
    respond_to do |format|
      format.html { redirect_to my_account_url, alert: 'Subscription was cancelled successfully' }
    end
  end
end
