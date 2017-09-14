module StripeHelper
  def convert_to_date(num)
    str = num.to_s
    Date.strptime(str, '%s')
  end
end
