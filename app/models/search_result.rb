class SearchResult
  attr_reader :type, :id, :data

  def initialize(type, id, data={})
    @type = type
    @id = id
    @data = OpenStruct.new(data)  # this is the normalized data field from Elasticsearch.
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
end
