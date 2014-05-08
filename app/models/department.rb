class Department < ApiClass
  # Virtus attributes
  attribute :id, Integer
  attribute :title, String
  attribute :image_url, String
  attribute :hours, String
  attribute :location, String
  attribute :contact_person, String
  attribute :phone, String
  attribute :email, String
  attribute :contacts, Array



  def to_s
    title
  end

  def self.api_path
    'department'
  end

end