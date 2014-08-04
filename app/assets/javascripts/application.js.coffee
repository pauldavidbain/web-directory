#  biola-frontend-toolkit includes jquery, jquery_ujs, and bootstrap
#= require biola-frontend-toolkit
#= require_tree .



# If the primary search form is available, just bring that into focus.
#  Otherwise, if you are on a show page for example, and the primary seach form
#  is not available, open up the global search form. This will drop down from the top.
window.toggleGlobalSearch = ->
  if $('#search_results_container .search_form').length > 0
    $('#search_results_container .search_form input#q').focus()
    $('#search_results_container .search_form input#q')[0].select()
  else if $('#global_search_form').is(":visible")
    $('#global_search_form').hide()
  else
    $('#global_search_form').show()
    $('#global_search_form input#q').focus()
    $('#global_search_form input#q')[0].select()


# Setup shortcut keys
$(document).keypress (e) ->
  if e.target == document.body
    switch e.charCode
      when 115 then toggleGlobalSearch(); return false; # "s" should bring up the global search.

# This closes the global search form if you hit the esc key inside of it
$('#global_search_form input#q').keydown (e) ->
  $('#global_search_form').hide() if e.keyCode == 27
