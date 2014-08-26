class PersonPresenter < ApplicationPresenter

  def assistants(type)
    content = object.assistants.map {|a| context.link_to(a.name, a) }.join("<br/>")
    send type, "Admin Assistant".pluralize(object.assistants.count), content
  end

  def department(type)
    content = if object.departments.first
      context.link_to object.departments.first.title, object.departments.first
    else
      object.department
    end
    send type, "Department", content
  end

  def social_media(type)
    send type, "Social Media", social_list(object.social_media)
  end

  def major(type)
    content = ""
    if object.major.present?
      content += object.major
      content += " - #{object.level}" if object.level.present?
    end
    send type, "Major", content
  end

  def emails(type)
    content = []
    content << object.work_email if object.work_email.present? && object.use_work_email?
    content << object.biola_email if object.biola_email.present? && context.policy(object).can_see_biola_email?
    send type, "Email".pluralize(content.length), content.map{|e| format_content(e, :email)}.join('<br/>')
  end

  def phones(type)
    content = []
    content << object.full_biola_phone_number(:alternate_employee_phone) if object.alternate_employee_phone.present? && context.policy(object).can_see_alternate_phone?
    content << object.full_biola_phone_number + " (Direct)" if object.full_biola_phone_number.present? && context.policy(object).can_see_employee_phone?
    send type, "Phone".pluralize(content.length), content.join('<br/>')
  end

  def visible_affiliations(type)
    if (affiliations = (object.visible_affiliations & UserPermissables.new(context.current_user).affiliations)).present?
      send type, "Biola Affiliations", affiliations.map{|a| a.to_s.titleize }.join(', ')
    end
  end
end
