module ApplicationHelper
  def form_field_errors(form, field_name)
    if form.object.errors.include?(field_name)
      form.object.errors.messages[field_name].collect do |message|
        content_tag(:p,
          html_escape(message),
          class: 'form-error is-visible')
      end.join.html_safe
    end
  end

  def help_text(field)
    content_tag :p, I18n.t("helpers.help_text.membership_application.#{field}"), class: 'help-text'
  end
end
