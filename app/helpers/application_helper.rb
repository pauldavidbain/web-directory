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
end
