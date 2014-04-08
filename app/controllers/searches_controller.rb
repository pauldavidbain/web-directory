class SearchesController < ApplicationController

  def landing
  end

  def search
    # See /config/initializers/webstubs.rb

    client = Elasticsearch::Client.new log: true
    search_body = {facets: { tag: { terms: { field: "facets" }}}}
    if params[:q].present?
      search_body[:query] = {
        multi_match: {
          query: params[:q],
          fields: ["*name^4", "job_title", "department", "location"]
        }
      }
    end

    es_results = client.search index: 'directory', body: search_body

    @results_count = es_results['hits']['total']
    @results = es_results['hits']['hits']
    @facets = es_results['facets']['tag']['terms']
  end

end