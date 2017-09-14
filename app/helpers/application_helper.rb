module ApplicationHelper
  def br(times)
    ("<br>" * times).html_safe
  end
end
