module StripeHelper
  def current_period_end
    convert_to_date @subscription.current_period_end
  end

  def trial_end_date
    convert_to_date @subscription.current_period_end
  end

  def convert_to_date(num)
    str = num.to_s
    Date.strptime(str, '%s')
  end
end
