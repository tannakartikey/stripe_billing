module MyAccountHelper
  def promotion_message_if_free_plan_users
    if current_user.plan.stripe_id.nil?
      benefits = "<br>
      <ul>
        <li>Benefit 1</li>
        <li>Benefit 2</li>
      </ul>
      </br>"
      "<br>Subscribe to our paid plan avail #{benefits}
      Go to #{link_to('Plans', plan_url)}".html_safe
    end
  end

  def if_no_payment_source_for_pro_user
    if current_user.payment_source.nil? && !current_user.plan.stripe_id.nil?
    "Enter your card details to continue using subscription<br>
     after trial end. You will be charged only after trial period".html_safe
    end
  end
end
