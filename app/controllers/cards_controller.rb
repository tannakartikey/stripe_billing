class CardsController < ApplicationController
  before_filter :authenticate
  def new
    @customer = StripeCustomer.retrieve(current_user) unless current_user.stripe_customer_id.nil?
    @card = Stripe::Source.retrieve(@customer.default_source).card unless current_user.payment_source.nil?
    @subscription = StripeSubscription.retrieve(current_user) unless current_user.subscription_id.nil?
  end

  def create
    begin
      @customer = StripeCustomer.retrieve(current_user)
      @source = @customer.sources.create({:source => params[:stripeSource]})
      @customer.default_source = @source.id
      @customer.save
      current_user.payment_source = @source.id
      current_user.save!
    rescue Stripe::CardError => error
      flash[:error] = error.message
      redirect_to new_card_path and return
    end

    if current_user.subscription_id == nil
      begin
        StripeSubscription.create(current_user)
      rescue Stripe::CardError => error
        flash[:error] = "There is some problem with your card. Please consult your bank"
        redirect_to new_card_path and return
      end
    end

    respond_to do |format|
      format.html { redirect_to my_account_path, notice: notice }
    end
  end

  private 

  def notice
    notice = 'Card was successfully updated.'
    if current_user.subscription_id.nil?
      notice += " You are successfully subscribed. Cheers!"
    end
    notice
  end
end