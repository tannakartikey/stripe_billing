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
end
