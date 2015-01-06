# NOTE: When changing this file make sure to also change index_elasticsearch.rake
#  and reindex_elasticsearch.rake within profile publisher as well.

# This reindex doesn't do anything gracefully. It completely destroys the index so there could be errors in between
#   deleting and reindexing. I would recommend putting the app into maintenence mode if uptime matters.
namespace :elasticsearch do
  desc 'Run all imports'

  task(:reindex => :environment) do
    Elasticsearch::Model.client.indices.delete index: Settings.elasticsearch.index_name

    config = BuwebContentModels::Configuration.new

    Elasticsearch::Model.client.indices.create index: Settings.elasticsearch.index_name, body: {settings: config.elasticsearch_settings, mappings: config.elasticsearch_mappings}

    config.elasticsearchable_models.each do |klass|
      puts "Reimporting #{klass.to_s.pluralize} into elasticsearch..."

      # TODO: This will import everyone, then the next line will go through and remove people who shouldn't be there.
      #   it would be better to only import the people who need to be there in the first place.
      #   So maybe `klass.import` isn't the best method to use here.
      klass.import

      # This will apply the correct rules to each object.
      klass.each { |obj| obj.add_to_index }
    end

    puts "\nAll done!\n\n"
  end
end
