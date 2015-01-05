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
      keys = Array(key_for_filter(r))

      # Group results by either last name or department.
      #  Doing it this way allows a person to be in mutiple groups (specifically departments).
      keys.each do |key|
        if key.present?
          @grouped_results[key] ||= []
          @grouped_results[key] << r
        end
      end
    end

    @keys = @grouped_results.keys.compact.sort
  end


  private

  # Return the key or keys for the given result based on the selected filter parameter.
  # For example, if the "department" filter is selected, and the person "r" has 2 departments,
  #   this method will return an array of those 2 departments.
  # If the "last_name" filter is selected, it will return the first letter of the person's last name.
  def key_for_filter(r)
    case params[:filter]
    when 'department'
      keys = r["_source"]["departments"]
      Array(keys).map do |key|
        key.gsub(/department( of )?/i, '').gsub(/.*School of/i, '').strip if key.present?
      end.compact
    else
      r["_source"]["last_name"].first
    end
  end

end
