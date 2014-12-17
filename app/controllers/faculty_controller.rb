class FacultyController < ApplicationController

  skip_after_action :verify_authorized, :verify_policy_scoped

  def index
    results = Elasticsearch::Model.client.search({
      index: Settings.elasticsearch.index_name,
      body: {
        sort: [
          { "last_name_raw" => { order: :asc }},
          { "normalized_data.title" => { order: :asc }},
        ],
        query: {
          filtered: {
            query: { match_all: {} },
            filter: { :and => [
              { term: { faculty_status: "full_time" }},
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
      key = key_for_filter(r)
      @grouped_results[key] ||= []
      @grouped_results[key] << r
    end

    @keys = @grouped_results.keys.compact.sort
  end


  private

  def key_for_filter(r)
    case params[:filter]
    when 'department'
      r["_source"]["department"]
    else
      r["_source"]["last_name"].first
    end
  end

end
