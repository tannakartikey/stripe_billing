class User < ActiveRecord::Base
  has_secure_password

  validates_uniqueness_of :email

  belongs_to :plan

  after_create :create_stripe_subscription

  def create_stripe_subscription
    unless self.plan.name == 'Free'
      StripeSubscription.create(self, self.plan.stripe_id, (Date.today + 14).to_time.to_i)
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
end
