class ApiClass
  # Attributes handling
  include Virtus.model

  # # ActiveModel
  extend  ActiveModel::Naming
  include ActiveModel::Conversion

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

  # Pass this method an array of IDs and it will hit the API and return an array of objects matching the ids.
  def self.initialize_from_ids(ids)
    ids.map { |id| self.find(id) }
  end

  # Overwrite this in the subclass
  def self.api_path
    ''
  end

  # This gets used by ActiveModel::Conversion when calling to_param.
  def persisted?
    id.present?
  end

private

  def self.not_found
    raise ActionController::RoutingError.new('Not Found')
  end

end