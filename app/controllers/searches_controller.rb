class SearchesController < ApplicationController

  def landing
  end

  def search
    # See /config/initializers/webstubs.rb

    # results = Elasticsearch::Model.client.search index: Settings.elasticsearch.index_name, body: search_body

    search_query = SearchQuery.new(params[:q], facets: facet_types, search_params: params)
    results = search_query.execute

    @results_count = results['hits']['total']
    @results = results['hits']['hits'] # these get turned into SearchResults in the view/helper
    @facets = results['facets']
    @facet_is_active = search_query.any_active_facets?
  end


private

  def facet_types
    ['_type', 'affiliations']
  end

end
