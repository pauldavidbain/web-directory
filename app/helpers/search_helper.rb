module SearchHelper

  def li_filter(title, type=nil)
    params_type = params['_type'].presence || 'all'
    active_class = ''
    if params_type == type
      active_class = 'active'
    end
    title = title.pluralize unless title == 'All'

    search_params = {'_type' => type}
    search_params[:q] = params[:q]
    if type == 'all' || type == 'person'
      search_params[:sort] = params[:sort]
      search_params[:affiliation] = params[:affiliation]
    end

    content_tag :li, class: "filter #{active_class}", 'data-type' => type do
      link_to title, search_path(search_params), remote: true
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
    SearchResult.new(es_result['_type'], es_result['_id'], es_result['_source'])
  end

  def result_url(search_result)
    if search_result.linkable?
      url_for controller: search_result.type.pluralize, action: 'show', id: (search_result.raw_data['slug'].presence || search_result.id)
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

  def search_title
    title = ""
    title += "\"#{params[:q]}\" | Search " if params[:q].present?
    title += if !params[:_type] || params[:_type] == 'all'
      'All'
    elsif params[:_type] == 'department'
      'Offices & Services'
    else
      params[:_type].pluralize.titleize
    end
    title + " | Directory, Biola University"
  end

  def selected_sort(type)
    type = 'all' if type.blank?
    sort_options(type).select{|opt| opt[:param] == params[:sort]}.first.try(:[], :title) || sort_options(type).first.try(:[], :title)
  end

  def sort_options(type)
    type = 'all' if type.blank?
    options = []
    options << {title: 'Name', param: 'title'} if type == 'all'
    options << {title: 'First Name', param: 'title'} if type == 'person'
    options << {title: 'Last Name', param: 'last_name'} if type == 'all' || type == 'person'
    options
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
