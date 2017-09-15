class InvoicesController < ApplicationController
  before_filter :authenticate
  def index
    @invoices = Invoice.
      find_all_by_stripe_customer_id(current_user.stripe_customer_id)
    @upcoming = Invoice.upcoming(current_user.stripe_customer_id)
  end
end
