#  biola-frontend-toolkit includes jquery, jquery_ujs, and bootstrap
#= require biola-frontend-toolkit
#= require jquery.mixitup
#= require jquery.embedforms
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
$(document).keyup (e) ->

  # ESC - lose focus from whatever is currently selected
  if e.keyCode == 27
    document.activeElement.blur()

  # "s" - bring up the global search.
  else if e.keyCode == 83 && e.target == document.body
    toggleGlobalSearch()
    return false # Otherwise the "s" will get put into the search field

# This closes the global search form if you hit the esc key inside of it
$('#global_search_form input#q').keydown (e) ->
  $('#global_search_form').hide() if e.keyCode == 27
