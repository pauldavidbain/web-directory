#  biola-style-guide includes jquery, jquery_ujs, and bootstrap
#= require biola-style-guide
#= require_tree .


if $('body.searches.landing').length > 0
  button_text = $('.jumbotron form button .text')
  $('#q').keyup ->
    console.log('pressed...')
    if $('#q').val().length > 0
      button_text.html('Search')
    else
      button_text.html('Browse')