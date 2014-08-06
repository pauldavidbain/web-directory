module SearchHelper

  def li_filter(title, type)
    active_class = ''
    if (params['_type'] == type) || (params['_type'].blank? && type == 'all')
      active_class = 'active'
    end
    title = title.pluralize unless title == 'All'
    content_tag :li, class: "filter #{active_class}", 'data-type' => type do
      link_to title, search_path(q: params[:q], '_type' => type), remote: true
    end
  end


  # def facet_link(group, facet)
  #   link_to facet_url_params(group, facet), class: (facet_is_active?(group, facet) ? 'active' : '') do
  #     content_tag(:div, facet['count'], class: 'tag') +
  #     content_tag(:span, facet['term'].titleize)
  #   end
  # end

  def facet_url_params(group, facet)
    merged_facets = if facet_is_active?(group, facet)
      current_facets(group) - [facet['term']]
    else
      current_facets(group) | [facet['term']]
    end
    params.merge(group => merged_facets)
  end

  def result_object(es_result)
    SearchResult.new(es_result['_type'], es_result['_id'], es_result['_source'])
  end

  def result_url(search_result)
    if search_result.linkable?
      url_for controller: search_result.type.pluralize, action: 'show', id: search_result.id, q: params[:q], _type: (params[:_type].presence || 'all')
    end
  end

  # If you are in a scope that would require you to login to see all results
  def in_private_scope
    params['_type'].blank? || params['_type'] == 'all' || params['_type'] == 'person'
  end


  def current_page
    (params[:page] || 1).to_i
  end
  def previous_page # we don't need to know the total_results for previous page
    current_page - 1 if current_page > 1
  end
  def next_page(total_results)
    current_page + 1 if current_page < total_results.to_i
  end

  def currently_showing(total_results)
    if total_results <= Settings.pagination_limit
      "all"
    else
      first = 1 + (current_page - 1) * Settings.pagination_limit
      last = [((first - 1) + Settings.pagination_limit), total_results].min
      "#{first} - #{last} of"
    end
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
