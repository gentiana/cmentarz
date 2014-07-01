module ApplicationHelper
  def alert(type, msg)
    content_tag(:div, msg, class: "alert alert-#{type}")
  end
end
