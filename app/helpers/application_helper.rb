module ApplicationHelper
  def alert_box(type, msg)
    # translate rails customary types to bootstrap types
    types = { notice: :info, error: :danger }
    content_tag(:div, msg, class: "alert alert-#{types[type.to_sym] || type}")
  end

  def set_title(title = nil)
    title ||= t('.title')
    provide(:title, title)
  end

  def page_title(subtitle = nil)
    subtitle.present? ? [t('title'), subtitle].join(' | ') : t('title')
  end

  def edit_btn(edit_path, options = {})
    text = t('.edit', default: t('helpers.links.edit'))
    defaults = { class: 'btn btn-default' }
    link_to text, edit_path, options.reverse_merge(defaults)
  end

  def delete_btn(resource_path, options = {})
    text = t('.destroy', default: t('helpers.links.destroy'))
    confirm = t('.confirm', default: t('helpers.links.confirm'))
    defaults = {
      class: 'btn btn-danger',
      method: 'delete',
      data: { confirm: confirm }
    }
    link_to text, resource_path, options.reverse_merge(defaults)
  end

  def field_label(field, options = {})
    label = t(".#{field}")
    raw "<strong>#{label}:</strong>#{'<br>' unless options[:no_br]}"
  end

  def link_with_name(resource)
    link_to resource.name, resource
  end

  def cancel_link(back_path)
    link_to t('helpers.links.cancel'), back_path, class: 'btn btn-default'
  end

  def create_notice(resource)
    t('flash.created', model: t("activerecord.models.#{resource}.one"))
  end

  def update_notice(resource)
    t('flash.updated', model: t("activerecord.models.#{resource}.one"))
  end

  def destroy_notice(resource)
    t('flash.destroyed', model: t("activerecord.models.#{resource}.one"))
  end
end
