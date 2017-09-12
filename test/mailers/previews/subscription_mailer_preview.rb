class SubscriptionMailerPreview < ActionMailer::Preview
  SubscriptionMailer.instance_methods(false).each do |method|
    define_method method do
      SubscriptionMailer.public_send(method, User.first)
    end
  end
  #def customer_subscription_trial_will_end
    #SubscriptionMailer.customer_subscirption_trial_will_end(User.first)
  #end 
end
