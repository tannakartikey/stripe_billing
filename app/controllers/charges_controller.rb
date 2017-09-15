class ChargesController < ApplicationController
  def new
  end

  def create
    begin
      Charge.create(User.find(params['/charge']['id']),
                     params['/charge']['amount'])
      redirect_to new_charge_path, notice: 'Successfully charged customer'
    rescue => error
      redirect_to new_charge_path, notice: error.message
    end
  end

  def show
    @charges = Charge.list_by_customer_stripe_id(current_user.stripe_customer_id)
  end
end
