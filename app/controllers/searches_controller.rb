class SearchesController < ApplicationController

  def landing
  end

  def search
    # See /config/initializers/webmock.rb
    # @results = Person.initialize_from_ids([1,2,3,4])

    client = Elasticsearch::Client.new log: true
    es_results = client.search index: 'directory', body: {
      query: {
        match: {
          _all: params[:q]
        }
      }
    }

    result_ids = es_results['hits']['hits'].map{|h| h['_source']['id']}
    @results = Person.initialize_from_ids(result_ids)

    @results_count = es_results['hits']['total']
  end

end