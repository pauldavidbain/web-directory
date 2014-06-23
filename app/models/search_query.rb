class SearchQuery
  attr_reader :term, :options, :search_params, :page, :per_page, :offset, :affiliations, :current_user

  def initialize(term, options={})
    if term.is_a?(Hash)
      options = term
      term = nil
    else
      term = term.to_s
    end

    @current_user = options[:current_user]
    @affiliations = @current_user.try(:affiliations) || []
    @term = term
    @options = options
    @search_params = options[:search_params] || {}

    # pagination
    @page = [options[:page].to_i, 1].max
    @per_page = (options[:limit] || options[:per_page] || 25).to_i
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
          type: 'cross_fields',
          operator: 'and',
          analyzer: 'standard',
          fields: [
            "title^4",
            "*_name",
            "*_initial",
            "preferred_name^4",
            "aliases",
            "subtitle^2",
            "department",
            "location",
            "email",
            "phone",
            "description",
            "titles"
          ]
        }
      }
    else
      { match_all: {} }
    end
  end

  def facet_filter
    _terms = []
    options[:facets].to_a.each do |type|
      search_params[type].to_a.each do |val|
        _terms << { term: { type => val }} if search_params[type]
      end
    end
    { :and => _terms } if _terms.length > 0
  end

  # This is to be used in the can_access_filter method
  def user_access_term_array(user)
    affiliations_to_term_array(user.affiliations_i_can_see)
  end

  def affiliations_to_term_array(affiliations = [])
    affiliations.map{|aff| { term: { affiliations: aff.to_s }}}
  end

  def can_access_filter
    # We only need to restrict access to people, not departments, groups, or services.
    #  So this is meant to be a catch all for those types of search results.
    non_person = { :or => [
                    { term: { _type: "department" }},
                    { term: { _type: "service" }},
                    { term: { _type: "group" }}
                  ]}

    if current_user.nil?
      { :or => [ non_person ] + affiliations_to_term_array([:faculty, :trustee]) }
    else
      { :or => [ non_person ] + user_access_term_array(current_user) }
    end
  end

  def facets
    _facets = {}
    (options[:facets] || []).each do |field|
      _facets[field] = { terms: { field: field }}
    end
    _facets
  end

  def all_filters
    {
      :and => [facet_filter, can_access_filter].compact
    }
  end

  def body
    {
      query: {
        filtered: {
          query: query,
          filter: all_filters
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
