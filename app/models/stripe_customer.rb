class StripeCustomer
    
  def self.create(user)
    user.payment_source = nil
    user.subscription_id = nil
    user.payment_source = nil
    customer = Stripe::Customer.create(email: user.email)
    user.stripe_customer_id = customer.id
    user.save!
  end
  
  def self.retrieve(user)
    Stripe::Customer.retrieve(user.stripe_customer_id)
  end

  def self.delete(user)
    self.retrieve(user).delete
  end

  def self.payment_source(user)
    self.retrieve(user).default_source
  end

  def self.delete_all_sources(user)
    customer = self.retrieve(user)
    customer.sources.each do |source|
      source.delete
    end
    user.payment_source = nil
    user.save!
  end

  def self.retrieve_or_create(user)
    if user.stripe_customer_id.nil?
      return self.create(user)
    else
      return self.retrieve(user)
    end
  end
end
