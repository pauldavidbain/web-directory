types = {
  person: [
    {id: 1, roles: ['employee', 'alumni'], first_name: 'Ryan', last_name: 'Hall', job_title: 'Web Programmer/Analyst', image_url: 'https://apps.biola.edu/idphotos/ef2092d948c316c13b9f7e62a937d6a6_medium.jpg', department: 'Information Technology', office_location: 'Lower Metzger East', phone: '562-944-0351', birthday: 'January, 30th 1992', ext: '1634', email: 'ryan.hall@biola.edu', responsibilities: 'Web application development and management.', cell: '456-798-1234'},
    {id: 2, roles: ['employee', 'alumni'], first_name: 'Mikel', last_name: 'Stefins', job_title: 'Web Programmer/Analyst', image_url: 'https://apps.biola.edu/idphotos/f164befff7ffa4bc097c240b40f6cb73_medium.jpg', department: 'Information Technology', office_location: 'Lower Metzger East', phone: '562-944-0351', birthday: 'April, 3rd 1998', ext: '3596', email: 'michael.stephens@biola.edu', responsibilities: 'Web application development and management.', cell: '195-431-7841'},
    {id: 3, roles: ['employee'], first_name: 'Adam', last_name: 'Crownoble', job_title: 'Web Programmer/Analyst', image_url: 'https://apps.biola.edu/idphotos/e01eec153ba24d1afba1aff96ccaa6bb_medium.jpg', department: 'Information Technology', office_location: 'The Grove', phone: '562-944-0351', ext: '4561', email: 'adam.crownoble@biola.edu', fax: '456-789-1234', office_location: 'Lower Metzger East', birthday: 'May 19th, 1976', responsibilities: 'Web application development and management.', cell: '194-675-2197'},
    {id: 4, roles: ['employee', 'alumni'], first_name: 'Devin', last_name: 'O\'Hanlon', job_title: 'Web Programmer/Analyst', image_url: 'https://apps.biola.edu/idphotos/852952cb170a3042077a28388f47e8a2_medium.jpg', department: 'Information Technology', office_location: 'Lower Metzger East', phone: '562-944-0351', birthday: 'March, 9th 1982', ext: '5035', email: 'devin.hanlon@biola.edu', responsibilities: 'Web application development and management.', cell: '858-518-1424', graduation_major: 'Computer Science', graduation_year: 'Fall, 2011'},

    {id: 5, roles: ['student'], first_name: 'Michael', last_name: 'Annunziata', image_url: '', birthday: '06/07/1984', email: 'michael.z.anunziata@biola.edu', cell: '713-392-1482', major: 'Communication Studies', personal_email: 'annunziata@yahoo.com', level: 'Freshmen'},
    {id: 6, roles: ['alumni'],  first_name: 'Lucy', last_name: 'Durniok', image_url: '', email: 'lucy.durniok@biola.edu', personal_email: 'lucy1@adelphia.net', cell: '649-126-9485', graduation_year: '2013', graduation_major: 'Equine Studies'},
    {id: 7, roles: ['faculty', 'employee'], first_name: 'John', last_name: 'Bloom', title: 'Professor', image_url: 'http://apps.biola.edu/idphotos/1b730e0ad1aaf1525bb1bb5f4fd2ba54.jpg', department: 'Chem Physics and Engineering', office_location: 'Upper Bardwell', phone: '564-242-2351', birthday: '11/25/1972', ext: '6442', email: 'john.bloom@biola.edu', responsibilities: 'Physics', cell: '879-165-4663'},
    {id: 8, roles: ['trustee'], first_name: 'Barry', last_name: 'Corry', job_title: 'President', image_url: 'http://apps.biola.edu/idphotos/5c7d9f02228781f1917f58b20bb37bf6.jpg', department: 'President CEO', office_location: 'Upper Metzger West', phone: '562-903-6000', birthday: '12/15/1987', ext: '4701', email: 'berry.corry@biola.edu', responsibilities: 'Presidential Dinners', cell: '568-743-1321'}
  ],
  department: [
    {id: 1, name: 'Information Technology', image_url: '', hours: 'M-F 8:00 am - 5:00 pm', location: 'Metzger Lower East'},
    {id: 2, name: 'Human Resources', image_url: '', hours: 'M-F 8:00 am - 5:00 pm', location: 'Metzger Upper West'},
    {id: 3, name: 'Business', image_url: '', hours: 'M-F 8:00 am - 5:00 pm', location: 'Business Building'}
  ]
}


# Enable web requests to localhost so that we can talk to the elasticsearch server
WebMock.disable_net_connect!(allow: ['login.biola.edu', 'localhost:9200'])


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
    # [:image_url].each {|key| e_index.delete(key)}

    # Index the remaining attributes
    client.index  index: 'directory', type: type.to_s, id: entity[:id], body: e_index
  end
end