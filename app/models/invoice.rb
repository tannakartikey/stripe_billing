class Invoice

  attr_reader :stripe_invoice

  def self.find_all_by_stripe_customer_id(stripe_customer_id)
    if stripe_customer_id.present?
      stripe_invoices_for_customer_id(stripe_customer_id).map do |invoice|
        new(invoice)
      end
    else
      []
    end
  end

  def initialize(invoice_id_or_invoice_object)
    if invoice_id_or_invoice_object.is_a? String
      @stripe_invoice = retrieve_stripe_invoice(invoice_id_or_invoice_object)
    else
      @stripe_invoice = invoice_id_or_invoice_object
    end
  end

  def stripe_invoice_id
    stripe_invoice.id
  end

  def number
    date.to_s(:invoice)
  end

  def total
    cents_to_dollars(stripe_invoice.total)
  end

  def paid?
    stripe_invoice.paid
  end

  def date
    convert_stripe_time(stripe_invoice.date)
  end

  def user
    @user ||= User.find_by(stripe_customer_id: stripe_invoice.customer)
  end

  def to_partial_path
    "invoices/#{self.class.name.underscore}"
  end

  def line_items
    stripe_line_items.map { |stripe_line_item| LineItem.new(stripe_line_item) }
  end

  def self.upcoming stripe_customer_id
    begin 
      new(Stripe::Invoice.upcoming(customer: stripe_customer_id))
    rescue Stripe::InvalidRequestError => error
      return nil
    end
  end

  private

  def self.stripe_invoices_for_customer_id(stripe_customer_id)
    Stripe::Invoice.all(customer: stripe_customer_id, count: 100).data
  end

  def retrieve_stripe_invoice(stripe_invoice_id)
    Stripe::Invoice.retrieve(stripe_invoice_id)
  end

  def cents_to_dollars(amount)
    amount / 100.0
  end

  def convert_stripe_time(time)
    Time.zone.at(time)
  end

  def stripe_line_items
    stripe_invoice.lines
  end
end
