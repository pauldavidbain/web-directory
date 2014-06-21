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

  def can_access_filter
    student    = { term: { affiliations: "student"   }}
    alumnus    = { term: { affiliations: "alumnus"   }}
    faculty    = { term: { affiliations: "faculty"   }}
    employee   = { term: { affiliations: "employee"  }}
    trustee    = { term: { affiliations: "trustee"   }}
    volunteer  = { term: { affiliations: "volunteer" }}
    non_person = { :or => [
                    { term: { _type: "department" }},
                    { term: { _type: "service" }},
                    { term: { _type: "group" }}
                  ]}

    if affiliations.include?('employee') || affiliations.include?('faculty')
      { :or => [ non_person, faculty, employee, trustee, volunteer, alumnus , student ]}
    elsif affiliations.include?('trustee') || affiliations.include?('volunteer')
      { :or => [ non_person, faculty, employee, trustee, volunteer, alumnus ]}
    elsif affiliations.include?('student') || affiliations.include?('student worker')
      { :or => [ non_person, faculty, employee, trustee, volunteer, student ]}
    elsif affiliations.include?('alumnus')
      { :or => [ non_person, faculty, employee, trustee, volunteer, alumnus ]}
    elsif current_user.nil?
      { :or => [ non_person, faculty, trustee ]}
    else
      { :or => [ non_person, faculty, trustee ]}
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