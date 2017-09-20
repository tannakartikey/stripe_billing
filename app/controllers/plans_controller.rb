class PlansController < ApplicationController
  before_filter :authenticate
  def show
    @plan = current_user.plan
    @plans = Plan.all.reject{ |plan| plan == @plan || plan == Plan.find_by_name('Free')}
  end

  def update
    plan = params['plan_update']['plan_id']
    old_plan = current_user.plan.name
    if current_user.stripe_customer_id.nil? || current_user.subscription_id.nil?
      begin
        StripeCustomer.create(current_user) if current_user.stripe_customer_id.nil?
        StripeSubscription.create(current_user, plan) if current_user.subscription_id.nil?
        send_plan_change_email(current_user, old_plan, Plan.find_by_stripe_id(plan).name)
        redirect_to my_account_path, notice: "Successfully changed plan"
      rescue => error
        redirect_to plan_url, notice: error.message
      end
    else
      begin
        StripeSubscription.update(current_user, plan)
        send_plan_change_email(current_user, old_plan, Plan.find_by_stripe_id(plan).name)
        redirect_to my_account_path, notice: "Successfully changed plan"
      rescue => error
        redirect_to plan_url, notice: error.message
      end
    end
  end


  private

  def send_plan_change_email(current_user, old_plan, new_plan)
    SubscriptionMailer.plan_change(current_user, old_plan, new_plan).deliver
  end
end
