module LinkHelper
  def social_link(account)
    icon, title = case account.type.to_s
    when 'linkedin' then ['linkedin-square', 'Linkedin']
    when 'facebook' then ['facebook-square', 'Facebook']
    when 'twitter' then ['twitter-square', 'Twitter']
    when 'google' then ['google-plus-square', 'Google+']
    when 'instagram' then ['instagram', 'Instagram']
    when 'pinterest' then ['pinterest-square', 'Pinterest']
    when 'youtube' then ['youtube-square', 'Youtube']
    else [nil, account.type.to_s.titleize]
    end

    if icon
      link_to fa_icon(icon, text: title), account.url, target: '_blank'
    else
      link_to title, account.url, target: '_blank'
    end
  end

  def website_link(url)
    return nil if url.blank?

    link_to url.to_s.gsub(/^https?:\/\//, '').truncate(40), url
  end

  def profile_publisher_link(object, name: 'Edit', action: 'edit', route: nil, css_class: 'btn btn-default', html_id: 'edit-in-publisher')
    route ||= object.class.to_s.downcase.pluralize
    link_to name, "#{Settings.profile_publisher.url}/#{route}/#{object.id}/#{action}", class: css_class, id: html_id
  end

  def params_with(extra_params={})
    whitelist = %w{sort page _type affiliation q}
    clean_params = params.each_with_object({}) do |(key, value), object|
      object[key] = value.to_s if whitelist.include? key.to_s
    end
    clean_params.merge(extra_params)
  end
end
