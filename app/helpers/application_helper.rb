module ApplicationHelper
  def alert(type, msg)
    content_tag(:div, msg, class: "alert alert-#{type}")
  end
  
  def set_title
    provide(:title, t('.title'))
  end
  
  def page_title(subtitle=nil)
    subtitle.present? ? [t('title'), subtitle].join(' | ') : t('title')
  end
end
