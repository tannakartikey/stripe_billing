class User < ActiveRecord::Base
  has_secure_password

  validates_uniqueness_of :email

  belongs_to :plan

  after_create :create_stripe_subscription

  def create_stripe_subscription
    unless self.plan.name == 'Free'
      StripeSubscription.create(self, self.plan.stripe_id, trial_end)
    end
  end

  def subscribed_to?
    plan.name
  end

  def subscribed_yearly?
    if plan.stripe_id.match(/yearly/) then true end
  end

  def subscribed_monthly?
    if plan.stripe_id.match(/monthly/) then true end
  end

  def trial_end
    if Rails.env.development? then return DateTime.now.to_i + 300 end
    if Rails.env.production? then return (Date.today + 14).to_time.to_i end
  end
end
