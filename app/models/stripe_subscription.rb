class StripeSubscription
  def self.create(user, plan, trial_end = 'now')
    StripeCustomer.create(user) if user.stripe_customer_id.nil?
    subscription = Stripe::Subscription.create(
                    :customer  => user.stripe_customer_id,
                    :plan      => plan,
                    :trial_end => trial_end,
                    :metadata  => { "automatic" => true },
                  )
    user.subscription_id = subscription.id
    user.is_active = true
    user.plan = Plan.find_by_stripe_id(plan) || Plan.find_by_name('Free')
    user.save!
  end

  def self.retrieve(user)
    Stripe::Subscription.retrieve(user.subscription_id) unless user.subscription_id.nil?
  end

  def self.delete(user, at_period_end)
    self.retrieve(user).delete(at_period_end: at_period_end)
  end

  def self.is_active? (user)
    StripeCustomer.retrieve(user).subscriptions.total_count == 0 ? false : true
  end
end
