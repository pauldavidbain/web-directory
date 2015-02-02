# Globally set up elasticsearch client
Elasticsearch::Model.client = Elasticsearch::Client.new log: Rails.env.development?, hosts: Settings.elasticsearch.hosts
