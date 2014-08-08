module ApplicationHelper

  def biola_person_image(netid, size=:medium)
    if netid.present?
      digest = Digest::MD5.hexdigest(netid.to_s)
      "https://apps.biola.edu/idphotos/#{digest}_#{size.to_s}.jpg"
    end
  end

  def divider(text=nil)
    content_tag :div, class: 'divider' do
      content_tag(:div, '', class: 'line') +
      if text.present?
        content_tag(:div, class: 'box_wrapper') do
          content_tag(:div, text, class: 'box')
        end
      else
        ''
      end
    end
  end

  def social_link(account)
    icon, title = case account.type.to_s
    when 'linked_in' then ['linkedin-square', 'Linkedin']
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

end
