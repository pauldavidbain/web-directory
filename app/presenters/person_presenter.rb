class PersonPresenter < ApplicationPresenter

  def assistants(type)
    content = format_content(object.assistants, :link).join("<br/>")
    send type, "Admin Assistant".pluralize(object.assistants.count), content
  end

  def departments(type)
    if object.departments.present?
      content = format_content(object.departments, :link).join("<br/>")
      count = object.departments.length
    else
      content =  object.department
      count = 1
    end
    send type, "Department".pluralize(count), content
  end

  def memberships(type)
    content = []
    content += object.group_memberships.to_a.map{|m| context.link_to(m.unitable, m.unitable) + ' ' + membership_tags(m)  }
    send type, "Member of", content, class: 'person_memberships'
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
    if context.policy(object).can_see_biola_email?
      content << object.work_email if object.work_email.present?
      content << object.biola_email if object.biola_email.present?
    end
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


  private

  def membership_tags(membership)
    (membership.team.to_a + membership.role.to_a).map do |tag|
      context.content_tag :span, tag, class: 'label label-light'
    end.join(' ').html_safe
  end
end
