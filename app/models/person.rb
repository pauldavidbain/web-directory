class Person < ApiClass
  # Virtus attributes
  attribute :id, Integer
  attribute :first_name, String
  attribute :last_name, String

  def self.api_path
    'person'
  end

end