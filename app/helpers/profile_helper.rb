module ProfileHelper
  def with_background_image(img, html_options={})
    if img.present?
      url = img.respond_to?(:url) ? img.url : img
      html_options[:style] = "background-image: url(#{url});"
      html_options[:class] = "with_image"
    else
      html_options[:class] = "without_image"
    end
    html_options
  end

  def membership_class(membership, html_options={})
    # These team classes are needed for the mixItUp plugin to work.
    html_options[:class] = membership.team.to_a.compact.map(&:parameterize).join(' ')
    html_options
  end
end
