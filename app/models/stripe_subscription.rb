class StripeSubscription
  def self.create(user, plan, trial_end = 'now')
    user.trial_allowed? ? trial_end = self.trial_end : trial_end = 'now'
    StripeCustomer.create(user) if user.stripe_customer_id.nil?
    subscription = Stripe::Subscription.create(
                    :customer  => user.stripe_customer_id,
                    :plan      => plan,
                    :trial_end => trial_end,
                    :metadata  => { "automatic" => true },
                  )
    user.subscription_id = subscription.id
    user.is_active = true
    user.trial_allowed = false
    user.plan = Plan.find_by_stripe_id(plan) || Plan.find_by_name('Free')
    user.save!
  end

  def self.retrieve(user)
    Stripe::Subscription.retrieve(user.subscription_id) unless user.subscription_id.nil?
  end

  def self.delete(user, at_period_end)
    self.retrieve(user).delete(at_period_end: at_period_end)
  end

  def self.update(user, plan)
    subscription = self.retrieve(user)
    item_id = subscription.items.data[0].id
    items = [{
      id: item_id,
      plan: plan,
    }]
    subscription.items = items
    subscription.save
    user.plan = Plan.find_by_stripe_id(plan)
    user.save!
  end

  def self.is_active? (user)
    StripeCustomer.retrieve(user).subscriptions.total_count == 0 ? false : true
  end

  def self.trial_end
    if Rails.env.development? then return DateTime.now.to_i + 300 end
    if Rails.env.production? then return (Date.today + 14).to_time.to_i end
  end
end
