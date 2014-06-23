class SearchesController < ApplicationController
  # We don't need to authorize with pundit for these actions.
  #  Anyone can see these pages and SearchQuery limits the results by user role.
  #  These get skipped over verify_authorized in the application_controller.

  def landing
  end

  def search
    search_query = SearchQuery.new(params[:q], facets: facet_types, search_params: params, current_user: current_user)
    results = search_query.execute

    @results_count = results['hits']['total']
    @results = results['hits']['hits'] # these get turned into SearchResults in the view/helper
    @facets = filter_facet_affiliations(results['facets'])
    @facet_is_active = search_query.any_active_facets?
  end


  private

  def facet_types
    ['_type', 'affiliations']
  end

  def filter_facet_affiliations(facets)
    permitted_affiliations = current_user.try(:affiliations_i_can_see) || [:faculty, :trustee]

    facets["affiliations"]["terms"] = facets["affiliations"]["terms"].map do |term|
      term if permitted_affiliations.include?(term["term"].to_sym)
    end.compact

    facets
  end

end
