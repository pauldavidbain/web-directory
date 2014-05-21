# Globally set up elasticsearch client
Elasticsearch::Model.client = Elasticsearch::Client.new log: true, host: Settings.elasticsearch.host
