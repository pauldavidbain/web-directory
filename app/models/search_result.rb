class SearchResult
  attr_reader :type, :id, :data, :affiliations, :department

  def initialize(type, id, data={}, affiliations=[], department=[])
    @type = type
    @id = id
    @data = OpenStruct.new(data)  # this is the normalized data field from Elasticsearch.
    @affiliations = affiliations
    department.present? ? @department = department : @department = ''
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
