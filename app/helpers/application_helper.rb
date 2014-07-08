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
  
  def edit_btn(edit_path)
    text = t('.edit', default: t("helpers.links.edit"))
    link_to text, edit_path, class: 'btn btn-default'
  end
  
  def delete_btn(resource_path)
    text = t('.destroy', default: t("helpers.links.destroy"))
    confirm = t('.confirm', default: t("helpers.links.confirm"))
    link_to text, resource_path, method: "delete", class: 'btn btn-danger',
            data: { confirm: confirm }
  end
  
  def field_label(field, options={})
    label = t(".#{field}")
    raw "<strong>#{label}:</strong>#{'<br>' unless options[:no_br]}"
  end
end
