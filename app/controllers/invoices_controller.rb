class InvoicesController < ApplicationController
  before_filter :authenticate
  def index
    @customer = StripeCustomer.retrieve(current_user)
    @upcoming_invoice = begin 
                          Stripe::Invoice.upcoming(customer: @customer.id)
                        rescue Stripe::InvalidRequestError => error
                          return nil
                        end
    #@invoices = @customer.invoices
    @invoices = Invoice.
      find_all_by_stripe_customer_id(current_user.stripe_customer_id)
  end
end
