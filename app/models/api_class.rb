class ApiClass
  # Attributes handling
  include Virtus.model

  # # ActiveModel
  # include ActiveModel::Validations
  # extend  ActiveModel::Naming
  # include ActiveModel::Conversion

  # HTTParty for actually grabbing the data from the API
  include HTTParty
  base_uri Settings.api_base

  def self.find(id)
    if id && response = self.get("/#{api_path}/#{id}")
      if response.success?
        self.new(JSON.parse(response.body))
      else
        not_found
      end
    else
      not_found
    end
  end

  # Overwrite this in the subclass
  def self.api_path
    ''
  end

private

  def self.not_found
    raise ActionController::RoutingError.new('Not Found')
  end

end