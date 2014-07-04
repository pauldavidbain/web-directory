class SearchResult
  attr_reader :type, :id, :data, :affiliations, :raw_data

  def initialize(type, id, raw_data)
    @type = type
    @id = id
    @data = OpenStruct.new(raw_data['normalized_data'])  # this is the normalized data field from Elasticsearch.
    @affiliations = raw_data['affiliations'] || []
    @raw_data = raw_data || {}
  end

  def icon
    case type
    when 'person' then 'user'
    when 'department' then 'building'
    when 'group' then 'users'
    when 'service' then 'support'
    else 'square-o'
    end
  end

  def linkable?
    type == 'person' ? (affiliations & ['faculty','employee']).any? : true
  end
end
