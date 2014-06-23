module SearchHelper

  def facet_link(group, facet)
    link_to facet_url_params(group, facet), class: (facet_is_active?(group, facet) ? 'active' : '') do
      content_tag(:div, facet['count'], class: 'tag') +
      content_tag(:span, facet['term'].titleize)
    end
  end

  def facet_url_params(group, facet)
    merged_facets = if facet_is_active?(group, facet)
      current_facets(group) - [facet['term']]
    else
      current_facets(group) | [facet['term']]
    end
    params.merge(group => merged_facets)
  end

  def result_object(es_result)
    SearchResult.new(es_result['_type'], es_result['_id'], es_result['_source']['normalized_data'], es_result['_source']['affiliations'], es_result['_source']['department'])
  end

  def result_url(search_result)
    url_for controller: search_result.type.pluralize, action: 'show', id: search_result.id
  end


private

  def facet_is_active?(group, facet)
    current_facets(group).include? facet['term']
  end

  def current_facets(group)
    params[group] || []
  end

  def param_facets
    params[:facets] || {}
  end
end
