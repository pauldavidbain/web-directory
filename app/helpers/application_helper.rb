module ApplicationHelper

  def biola_person_image(netid, size=:medium)
    if netid.present?
      digest = Digest::MD5.hexdigest(netid.to_s)
      "https://apps.biola.edu/idphotos/#{digest}_#{size.to_s}.jpg"
    end
  end

  def divider(icon='joomla')
    content_tag :div, class: 'divider' do
      content_tag(:div, '', class: 'line') +
      content_tag(:div, fa_icon(icon), class: 'circle')
    end
  end

end
