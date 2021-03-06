class ChargesController < ApplicationController
  wrap_parameters false
  def new
  end

  def create
    begin
      Charge.create(
        User.find(params['new_charge']['user_id']),
        params['new_charge']['amount'].to_i * 100,
        params['new_charge']['description']
      )
      redirect_to new_charge_path, notice: 'Successfully charged customer'
    rescue => error
      redirect_to new_charge_path, notice: error.message
    end
  end

  def show
    @charges = Charge.list_by_customer_stripe_id(current_user.stripe_customer_id)
  end

  def repay
    begin
      Charge.create(
        User.find(params['user_id']),
        params['amount'].to_i * 100,
        "Repayment of charge: " + params[:charge_id]
      )
      redirect_to charge_path, notice: 'Successfully repayed!'
    rescue => error
      redirect_to new_charge_path, notice: error.message
    end
  end
end
