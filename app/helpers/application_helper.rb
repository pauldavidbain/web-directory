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
    icon = case account.type.to_s
    when 'linked_in' then 'linkedin-square'
    when 'facebook' then 'facebook-square'
    when 'twitter' then 'twitter-square'
    when 'gplus' then 'google-plus-square'
    when 'instagram' then 'instagram'
    when 'pinterest' then 'pinterest-square'
    when 'youtube' then 'youtube-square'
    else nil
    end

    link_to fa_icon(icon), account.url, target: '_blank'
  end

end
