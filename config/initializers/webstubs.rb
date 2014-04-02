types = {
  person: [
    {id: 1, first_name: 'Ryan', last_name: 'Hall', job_title: 'Web Programmer/Analyst', image_url: 'https://apps.biola.edu/idphotos/ef2092d948c316c13b9f7e62a937d6a6_medium.jpg', roles: ['staff', 'alumni'], email: 'ryan.hall@biola.edu'},
    {id: 2, first_name: 'Mikel', last_name: 'Stefins', job_title: 'Web Programmer/Analyst', image_url: 'https://apps.biola.edu/idphotos/f164befff7ffa4bc097c240b40f6cb73_medium.jpg', roles: ['staff', 'alumni'], vocation: 'Professional Gamer', email: 'michael.stephens@biola.edu', phone: '555-555-5555'},
    {id: 3, first_name: 'Adam', last_name: 'Crownoble', job_title: 'Web Programmer/Analyst', image_url: 'https://apps.biola.edu/idphotos/e01eec153ba24d1afba1aff96ccaa6bb_medium.jpg', roles: ['staff'], department: 'Computer Science', department_location: 'The Grove', phone: '562-944-0351', ext: '4561', email: 'adam.crownoble@biola.edu', fax: '456-789-1234'},
    {id: 4, first_name: 'Devin', last_name: 'O\'Hanlon', job_title: 'Web Programmer/Analyst', image_url: 'https://apps.biola.edu/idphotos/852952cb170a3042077a28388f47e8a2_medium.jpg', roles: ['staff', 'alumni'], department: 'IT', department_location: 'Lower Metzger East', phone: '562-944-0351', extension: '5035', email: 'devin.hanlon@biola.edu'}
  ],
  department: [
    {id: 1, name: 'Information Technology', image_url: 'https://apps.biola.edu/idphotos/ef2092d948c316c13b9f7e62a937d6a6_medium.jpg', hours: 'M-F 8:00 am - 5:00 pm', department_location: 'Metzger Lower East'}
  ]
}


# Enable web requests to localhost so that we can talk to the elasticsearch server
WebMock.disable_net_connect!(:allow_localhost => true)


# Stub out the API requests with Webmock
types.each do |type, entities|
  entities.each do |entity|
    url = "http://#{Settings.api_base}/#{type.to_s}/#{entity[:id]}"
    WebMock.stub_request(:get, url).
      to_return(:status => 200, :body => entity.to_json, :headers => {})
  end
end


# Stub out the Elastisearch results
client = Elasticsearch::Client.new log: true
types.each do |type, entities|
  entities.each do |entity|
    e_index = entity.dup

    # strip unneeded attributes
    [:image_url].each {|key| e_index.delete(key)}

    # Index the remaining attributes
    client.index  index: 'directory', type: type.to_s, id: entity[:id], body: e_index
  end
end