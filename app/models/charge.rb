class Charge
  attr_reader :charge

  def self.list_by_customer_stripe_id(stripe_customer_id)
    if stripe_customer_id.present?
      stripe_charges_for_customer_id(stripe_customer_id).map do |charge|
        new(charge)
      end
    else
      []
    end end 
  def self.create(user, amount, description=nil)
    begin
      Stripe::Charge.create(
        customer: user.stripe_customer_id,
        amount: amount,
        currency: "usd",
        description: description,
        metadata: {"extra_charge" => true}
      )
      user.charge_failed = false
      user.save!
    rescue
      user.charge_failed = true
      user.save!
    end
  end

  def initialize(charge)
    @charge = retrieve_charge(charge.id)
  end

  def methods
    charge.methods
  end

  def id
    charge.id
  end

  def date
    convert_stripe_time(charge.created)
  end

  def amount
    charge.amount
  end

  def status
    charge.status
  end

  def paid?
    charge.paid
  end

  def description
    charge.description
  end

  def to_partial_path
    "charges/#{self.class.name.underscore}"
  end

  def refunded?
    charge.refunded
  end

  private

  def self.stripe_charges_for_customer_id(stripe_customer_id)
    Stripe::Charge.list(customer: stripe_customer_id)
  end

  def retrieve_charge(stripe_charge_id)
    Stripe::Charge.retrieve(stripe_charge_id)
  end

  def convert_stripe_time(time)
    Time.zone.at(time)
  end
end
