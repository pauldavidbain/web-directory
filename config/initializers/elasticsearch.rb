# Globally set up elasticsearch client
Elasticsearch::Model.client = Elasticsearch::Client.new log: (Rails.env == 'development'), host: Settings.elasticsearch.host
