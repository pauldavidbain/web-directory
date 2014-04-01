class SearchesController < ApplicationController

  def landing
  end

  def search
    data = [
      {id: 1, first_name: 'Ryan', last_name: 'Hall', image_url: 'https://apps.biola.edu/idphotos/ef2092d948c316c13b9f7e62a937d6a6_medium.jpg'},
      {id: 2, first_name: 'Mikel', last_name: 'Stefins', image_url: 'https://apps.biola.edu/idphotos/f164befff7ffa4bc097c240b40f6cb73_medium.jpg'},
      {id: 3, first_name: 'Adam', last_name: 'Crownoble', image_url: 'https://apps.biola.edu/idphotos/e01eec153ba24d1afba1aff96ccaa6bb_medium.jpg'},
      {id: 4, first_name: 'Devin', last_name: 'O\'Hanlon', image_url: 'https://apps.biola.edu/idphotos/852952cb170a3042077a28388f47e8a2_medium.jpg'}
    ]

    @results = Person.initialize_from_array(data)
  end

end