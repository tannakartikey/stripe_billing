class StripeController < ApplicationController
  protect_from_forgery :except => :events
  def events
    request.body.rewind
    payload = JSON.parse(request.body.read)
    event = nil
    event_id = payload["id"]
    if Rails.env.production?
      event = Stripe::Event.retrieve(event_id)  #so that we know event is valid and from Stripe
    else
      event = JSON.parse(request.body.read, object_class: OpenStruct)
    end
    if event
      Thread.new do
        customer = event.data.object.customer
        user = User.find_by(stripe_customer_id: customer)
        event_type = event.type
        event_process(event_type, event, user, customer)
        ActiveRecord::Base.connection.close
      end
    end
    render nothing: true, status: 200
  end

  def event_process(event_type, event, user, customer)
    case event_type
    when "customer.subscription.trial_will_end"
      #triggers three days before trial going to add
      #reming the user by email to add payment source
      SubscriptionMailer.customer_subscription_trial_will_end(user).deliver

    when "customer.subscription.deleted"
      #after three failed payment attempts as per the settings subscription will be deleted
      user.subscription_id = nil
      user.is_active = false
      user.trial_allowed = false
      user.save!
      StripeCustomer.delete_all_sources(user)
      SubscriptionMailer.customer_subscription_deleted(user).deliver

    when "customer.subscription.updated"
      #to capture subscription from trial to active
      if event.data.object.status == "active" && event.data.previous_attributes.status == "trialing" 
        if user.payment_source == nil
          user.is_active = false
          user.trial_allowed = false
          user.save!
          SubscriptionMailer.customer_subscription_updated(user).deliver
        else
          SubscriptionMailer.trial_over(user).deliver
        end
      elsif event.data.previous_attributes.trial_end.present?
        user.is_active = true
        user.save!
        trial_end_date = Date.strptime(event.data.object.trial_end.to_s, '%s')
        SubscriptionMailer.trial_extended(user, trial_end_date).deliver
      end

    when "invoice.upcoming"
      #if source added, notify customer about upcoming payment deduction
      unless event.data.object.total == 0
        SubscriptionMailer.invoice_upcoming(user).deliver
      end

    when "invoice.updated"
      if event.previous_attributes.attempt_count >= 0
        next_attempt = event.previous_attributes.next_payment_attempt
      end

    when "charge.failed"
      source = event.data.object.source.last4
      error = event.data.object.outcome.seller_message
      SubscriptionMailer.charge_failed(user, source, error).deliver

    when "invoice.payment_failed"
      next_payment_attempt = event.data.object.next_payment_attempt
      unless next_payment_attempt.nil?
        next_payment_attempt = Date.strptime(next_payment_attempt.to_s, '%s')
        SubscriptionMailer.invoice_payment_failed(user, next_payment_attempt).deliver
      end

    when "invoice.payment_succeeded"
      user.is_active = true
      user.save!
      SubscriptionMailer.invoice_payment_succeeded(user).deliver

    when "customer.source.created"
      source = event.data.object.card.last4
      SubscriptionMailer.customer_source_created(user, source).deliver

    when "customer.subscription.created"
      user.subscription_id =  event.data.object.id
      user.is_active = true
      user.save!
      SubscriptionMailer.customer_subscription_created(user).deliver unless event.data.object.metadata.methods(false).include? :automatic

    else
      #Every other event we are not handling
      if Rails.env.development?
        #OtherEventsMailer.notify(request.body.read)
      end
    end
  end
end
