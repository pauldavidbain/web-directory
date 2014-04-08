class Person < ApiClass
  # Virtus attributes
  attribute :id, Integer
  attribute :first_name, String
  attribute :middle_name, String
  attribute :last_name, String
  attribute :job_title, String
  attribute :other_title, String
  attribute :image_url, String
  attribute :email, String
  attribute :phone, String
  attribute :ext, String
  attribute :birthday, String
  attribute :cell, String
  attribute :responsibilities, String
  attribute :projects, String
  attribute :roles, String
  attribute :department, String
  attribute :office_location, String
  attribute :fax, String
  attribute :bio, String
  attribute :website, String
  attribute :web_presence, String
  attribute :personal_email, String
  attribute :major, String
  attribute :minor, String
  attribute :level, String
  attribute :office_hours, String
  attribute :home_phone, String
  attribute :graduation_year, String



  def to_s
    name
  end

  def name
    "#{first_name} #{last_name}"
  end

  def self.api_path
    'person'
  end

end