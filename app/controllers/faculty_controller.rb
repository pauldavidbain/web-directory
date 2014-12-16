class FacultyController < ApplicationController

  skip_after_action :verify_authorized, :verify_policy_scoped

  def index
    results = Elasticsearch::Model.client.search({
      index: Settings.elasticsearch.index_name,
      body: {
        sort: [
          { "last_name" => { order: :asc }},
          { "normalized_data.title" => { order: :asc }},
        ],
        query: {
          filtered: {
            query: { match_all: {} },
            filter: { :and => [
              { term: { affiliations: "faculty" }},
              { term: { is_public: true }}
            ]}
          }
        }
      },
      size: 1000
    })

    @grouped_results = {}

    results["hits"]["hits"].each do |r|
      key = r["_source"]["last_name"].first
      @grouped_results[key] ||= []
      @grouped_results[key] << r
    end
  end
end
