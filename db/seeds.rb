# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'elasticsearch'

client = Elasticsearch::Client.new log: true
entities = [
      { index: 'dir', type: 'department', id: 1,
        body: { name: 'Information Technology', image_url: 'https://apps.biola.edu/idphotos/ef2092d948c316c13b9f7e62a937d6a6_medium.jpg', hours: 'M-F 8:00 am - 5:00 pm', department_location: 'Metzger Lower East' }
      },
      { index: 'dir', type: 'person', id: 2,
        body: { role: 'student', first_name: 'Ryan', last_name: 'Hall', image_url: 'https://apps.biola.edu/idphotos/ef2092d948c316c13b9f7e62a937d6a6_medium.jpg', email: 'ryan.hall@biola.edu' }
      },
      { index: 'dir', type: 'person', id: 3,
        body: { role: 'alumni', first_name: 'Mikel', last_name: 'Stefins', image_url: 'https://apps.biola.edu/idphotos/f164befff7ffa4bc097c240b40f6cb73_medium.jpg', vocation: 'Professional Gamer', email: 'michael.stephens@biola.edu', phone: '555-555-5555'}
      },
      { index: 'dir', type: 'person', id: 4,
        body: { role: 'faculty', first_name: 'Adam', last_name: 'Crownoble', image_url: 'https://apps.biola.edu/idphotos/e01eec153ba24d1afba1aff96ccaa6bb_medium.jpg', department: 'Computer Science', department_location: 'The Grove', phone: '562-944-0351', ext: '4561', email: 'adam.crownoble@biola.edu', fax: '456-789-1234'}
      },
      { index: 'dir', type: 'person', id: 5,
        body: { role: 'staff', first_name: 'Devin', last_name: 'O\'Hanlon', image_url: 'https://apps.biola.edu/idphotos/852952cb170a3042077a28388f47e8a2_medium.jpg', department: 'IT', department_location: 'Lower Metzger East', phone: '562-944-0351', extension: '5035', email: 'devin.hanlon@biola.edu' }
      }
    ]
entities.each{ |e| client.index e }

