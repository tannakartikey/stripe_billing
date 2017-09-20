class SubscriptionMailer < ActionMailer::Base

  default from: 'info@app_name.com'

  def customer_subscription_trial_will_end(user)
    @user = user
    mail(to: @user.email, subject: subject("Your trial period is going to end"))
  end

  def customer_subscription_deleted(user)
    @user = user
    mail(to: @user.email, subject: subject("Subscription is cancelled"))
  end

  def customer_subscription_updated(user)
    @user = user
    mail(to: @user.email, subject: subject("Your trial period has ended"))
  end

  def trial_over(user)
    @user = user
    mail(to: @user.email, subject: subject("Your trial period has ended"))
  end

  def trial_extended(user, trial_end_date = nil)
    @user = user
    @trial_end_date = trial_end_date
    mail(to: @user.email, subject: subject("Your trial period is extended"))
  end

  def invoice_upcoming(user)
    @user = user
    mail(to: @user.email, subject: subject("Invoice will be created in three days"))
  end

  def invoice_updated(user)
  end

  def charge_failed(user, source = nil, error = nil)
    @user = user
    @source = source
    @error = error
    mail(to: @user.email, subject: subject("We failed to charge your card"))
  end

  def charge_succeeded(user, amount = nil, descriptoin = nil)
    @user = user
    @amount = amount
    @description = descriptoin || ''
    mail(to: @user.email, subject: subject("We successfully charged you extra"))
  end

  def invoice_payment_failed(user, next_payment_attempt = nil)
    @user = user
    @next_payment_attempt = next_payment_attempt
    mail(to: @user.email, subject: subject("We failed to charge your card"))
  end

  def invoice_payment_succeeded(user, amount = nil)
    @user = user
    @amount = amount
    mail(to: @user.email, subject: subject("We successfully received your payment"))
  end
  
  def source_chargeable(user, source=nil)
    @user = user
    mail(to: @user.email, subject: subject("Your payment source was updated"))
  end

  def customer_subscription_created(user)
    @user = user
    mail(to: @user.email, subject: subject("Your subscription at <app name> is created"))
  end

  def charge_refunded(user, amount = nil)
    @user = user
    @amount = amount
    mail(to: @user.email, subject: subject("You have received the refund"))
  end

  def plan_change(user, old_plan = nil, new_plan = nil, trial_allowed = nil)
    @user = user
    @old_plan = old_plan
    @new_plan = new_plan
    @trial_allowed = trial_allowed
    mail(to: @user.email, subject: subject("Successfully changed the plan"))
  end


  private
  
  def subject(subject)
    "<app_name> | " + subject.titlecase
  end

end
