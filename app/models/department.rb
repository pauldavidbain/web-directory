class Department < ApiClass
  # Virtus attributes
  attribute :id, Integer
  attribute :name, String
  attribute :image_url, String
  attribute :hours, String
  attribute :location, String
  attribute :contact_person, String
  attribute :phone, String
  attribute :email, String



  def to_s
    name
  end

  def self.api_path
    'department'
  end

end