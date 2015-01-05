if $("#search_results_container").length > 0

  $("#search_results_container").on 'ajax:before', (event, xhr, status) ->
    $("#search_results").html("<div class='spinner-wrapper'><i class='fa fa-spinner fa-spin'></i></div>")

  $("#search_results_container").on 'ajax:error', (event, xhr, status) ->
    $("#search_results").html("<div class='alert alert-danger'>There was an while searching. Please refresh the page and try again.</div>")



# Focus and set cursor to the end of the search field
window.focusSearch = ->
  if search_input = $("#q")[0]
    search_input.focus()
    if search_input.setSelectionRange
      len = search_input.value.length * 2
      search_input.setSelectionRange len, len
    else
      search_input.value = search_input.value


focusSearch()


# Open and close the search filter on smaller screens.
$("#search_results_container").on "click", "li.filter.active", ->
  $(this).parent().toggleClass "open"
  false
