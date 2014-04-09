class SearchesController < ApplicationController

  def landing
  end

  def search
    # See /config/initializers/webstubs.rb

    client = Elasticsearch::Client.new log: true
    es_results = client.search index: 'directory', body: search_body

    @results_count = es_results['hits']['total']
    @results = es_results['hits']['hits']
    @facets = es_results['facets']['tag']['terms']
  end




private

  ###
  ### Methods for building out the ElasticSearch query
  ###
  def search_body
    filter_search build_facets filter_facets({query: { filtered: { query: {}}}})
  end

  def filter_search(es)
    if params[:q].present?
      es[:query][:filtered][:query][:multi_match] = {
        query: params[:q],
        fields: ["*name^4", "job_title", "department", "location"]
      }
    else
      es[:query][:filtered][:query][:match_all] = {}
    end
    return es
  end

  def filter_facets(es)
    and_terms = (params[:facets] || []).map do |facet|
      { term: { facets: facet } }
    end
    es[:query][:filtered][:filter] = { :and => and_terms } if and_terms.length > 0
    return es
  end

  def build_facets(es)
    es[:facets] = { tag: { terms: { field: "facets" }}}
    return es
  end

end