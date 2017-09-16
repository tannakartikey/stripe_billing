class PlansController < ApplicationController
  before_filter :authenticate
  def show
    @plan = current_user.plan
    @plans = Plan.all.reject{ |plan| plan == @plan || plan == Plan.find_by_name('Free')}
  end

  def update
    plan = params['plan_update']['plan_id']
    if current_user.stripe_customer_id.nil? || current_user.subscription_id.nil?
      begin
        StripeCustomer.create(current_user) if current_user.stripe_customer_id.nil?
        StripeSubscription.create(current_user, plan) if current_user.subscription_id.nil?
        redirect_to my_account_path, notice: "Successfully changed plan"
      rescue => error
        redirect_to plan_url, notice: error.message
      end
    else
      begin
        StripeSubscription.update(current_user, plan)
        redirect_to my_account_path, notice: "Successfully changed plan"
      rescue => error
        redirect_to plan_url, notice: error.message
      end
    end
  end
end
