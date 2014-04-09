module SearchHelper

  def facet_link(facet)
    link_to facet_url_params(facet), class: (facet_is_active?(facet) ? 'active' : '') do
      content_tag(:div, facet['count'], class: 'tag') +
      content_tag(:span, facet['term'].titleize)
    end
  end

  def facet_url_params(facet)
    merged_facets = if facet_is_active?(facet)
      current_facets - [facet['term']]
    else
      current_facets | [facet['term']]
    end
    params.merge(facets: merged_facets)
  end

private

  def facet_is_active?(facet)
    current_facets.include? facet['term']
  end

  def current_facets
    params[:facets] || []
  end
end