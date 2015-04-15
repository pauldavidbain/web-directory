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
            "title_edge^3",
            "aliases^5",
            "first_name",
            "last_name^2",
            "previous_last_name",
            "preferred_name^4",
            "legal_name",
            "*_initial",
            "department",
            "department_aliases",
            "location",
            "email",
            "phone",
            "titles^2",
            "biola_title",
            "affiliations"
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
      if val = search_params[type]
        _terms << { term: { type => val }} unless val == 'all' || val.blank?
      end

      # search_params[type].to_a.each do |val|
      #   _terms << { term: { type => val }} if search_params[type]
      # end
    end
    { :and => _terms } if _terms.length > 0
  end

  def affiliations_user_can_see(user)
    affiliations_to_term_array(UserPermissables.new(user).affiliations)
  end

  def affiliations_to_term_array(affiliations = [])
    affiliations.map{|aff| { term: { affiliations: aff.to_s }}}
  end

  def non_person_filter
    # We only need to restrict access to people, not departments, or groups.
    #  So this is meant to be a catch all for those types of search results.
    { :or => [
      { term: { _type: "department" }},
      { term: { _type: "group" }}
    ]}
  end

  def type_filter
    # Limit "All" search to only type the directory cares about. This will exclude events and other things
    #   we add to the elasticsearch index in the future
    { :or => [
      { term: { _type: "person" }},
      { term: { _type: "department" }},
      { term: { _type: "group" }}
    ]}
  end

  def can_access_filter
    # Either it is not a person or the user has permission on one of the person's indexed affiliations
    { :or => [non_person_filter] + affiliations_user_can_see(current_user) }
  end

  def public_filter
    if current_user
      {}
    else  # Limit to only public items for unauthenticated users.
      { term: { is_public: true }}
    end
  end

  def affiliation_filter
    # Make sure the current user is able to see the affiliation if there is one.
    if search_params[:affiliation].present? && UserPermissables.new(current_user).affiliations.map(&:to_s).include?(search_params[:affiliation])
      { term: { affiliations: search_params[:affiliation] }}
    else
      {}
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
      :and => [facet_filter, can_access_filter, public_filter, affiliation_filter, type_filter].compact
    }
  end

  def sort_by
    if order = search_params[:sort]
      if order == 'title'
        [
          { "_type" => { order: :asc }},
          { "normalized_data.title" => { order: :asc }},
          # { "preferred_name" => { order: :asc }},
        ]
      elsif order == 'last_name'
        [
          { "_type" => { order: :asc }},
          { "last_name_raw" => { order: :asc }},
          { "normalized_data.title" => { order: :asc }},
        ]
      else  # this includes 'relevance'
        []
      end
    else
      [
        { "_type" => { order: :asc }},
        { "last_name_raw" => { order: :asc }},
        { "normalized_data.title" => { order: :asc }},
      ]
    end
  end

  def body
    {
      sort: sort_by,
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
