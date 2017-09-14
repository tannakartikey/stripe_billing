class MyAccountController < ApplicationController
  before_filter :authenticate, only: [:index]
  before_filter :authorize, only: [:pro]
  def index
  end
  def destroy
    StripeSubscription.delete(current_user)
    respond_to do |format|
      format.html { redirect_to my_account_url, alert: 'Subscription was cancelled successfully' }
    end
  end
end
