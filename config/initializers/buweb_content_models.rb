BuwebContentModels.configure do |config|
  config.elasticsearch_host = Settings.elasticsearch.host
  config.elasticsearch_index = Settings.elasticsearch.index_name
end