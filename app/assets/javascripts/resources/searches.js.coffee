if $("#search_results_container").length > 0

  $("#search_results_container").on 'ajax:before', (event, xhr, status) ->
    $("#search_results").html("<div class='spinner-wrapper'><i class='fa fa-spinner fa-spin'></i></div>")

  $("#search_results_container").on 'ajax:error', (event, xhr, status) ->
    $("#search_results").html("<div class='alert alert-danger'>There was an while searching. Please refresh the page and try again.</div>")
