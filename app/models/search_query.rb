class SearchQuery
  attr_reader :term, :options, :search_params, :page, :per_page, :offset

  def initialize(term, options={})
    if term.is_a?(Hash)
      options = term
      term = nil
    else
      term = term.to_s
    end

    @term = term
    @options = options
    @search_params = options[:search_params] || {}

    # pagination
    @page = [options[:page].to_i, 1].max
    @per_page = (options[:limit] || options[:per_page] || 100).to_i
    @offset = options[:offset] || (page - 1) * per_page
  end

  def execute
    client.search(params)
  end

  def any_active_facets?
    options[:facets].each do |type|
      return true if search_params[type].present?
    end
    return false
  end


private

  def query
    if term.present?
      {
        multi_match: {
          query: term,
          fields: ["title^4", "*name^4", "aliases^2", "subtitle", "department", "location", "email", "phone", "description"]
        }
      }
    else
      { match_all: {} }
    end
  end

  def and_filters
    _terms = (options[:facets] || []).map do |type|
      { term: { type => search_params[type] }} if search_params[type]
    end.compact
    { :and => _terms } if _terms.length > 0
  end

  def facets
    _facets = {}
    (options[:facets] || []).each do |field|
      _facets[field] = { terms: { field: field }}
    end
    _facets
  end

  def body
    {
      query: {
        filtered: {
          query: query,
          filter: and_filters
        }
      },
      facets: facets,
      size: per_page,
      from: offset
    }
  end

  def params
    {
      index: Settings.elasticsearch.index_name,
      body: body
    }
  end

  def client
    Elasticsearch::Model.client
  end
end
