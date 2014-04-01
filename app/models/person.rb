class Person < ApiClass
  # Virtus attributes
  attribute :id, Integer
  attribute :first_name, String
  attribute :last_name, String
  attribute :image_url, String

  def to_s
    "#{first_name} #{last_name}"
  end

  def self.api_path
    'person'
  end

  def self.initialize_from_array(array)
    array.map { |attributes| Person.new(attributes) }
  end

end