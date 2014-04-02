class Person < ApiClass
  # Virtus attributes
  attribute :id, Integer
  attribute :first_name, String
  attribute :last_name, String
  attribute :job_title, String
  attribute :image_url, String

  def to_s
    name
  end

  def name
    "#{first_name} #{last_name}"
  end

  def self.api_path
    'person'
  end

  def self.initialize_from_ids(ids)
    ids.map { |id| Person.find(id) }
  end

end