// See https://gist.github.com/halloffame/d8bcb9e469b33b05a457
//
// The problem is that when you use remote=true links, it doesn't update the url.
//   This code updates the url when you follow those links/form.
//

function historySupport() {
  return !!(window.history && window.history.pushState !== undefined);
}

function pushPageState(state, title, href) {
  if (historySupport()) {
    history.pushState(state, title, href);
  }
}

function replacePageState(state, title, href) {
  if (state == undefined) { state = null; }

  if (historySupport()) {
    history.replaceState(state, title, href);
  }
}

$(function() {
  if ($("#search_results_container").length > 0) {

    window.onpopstate = function(e) {
      if ($('body').attr('data-state-href') === location.href) {
        return false;
      }

      if (e.state !== null) {
        // do something with your state object
      }

      $.ajax({
        url: location.href,
        dataType: 'script',
        success: function(data, status, xhr) {
          $('body').trigger('ajax:success');
        },
        error: function(xhr, status, error) {
          // You may want to do something else depending on the stored state
          // alert('Failed to load ' + location.href);
          window.location = location.href;
        },
        complete: function(xhr, status) {
          $('body').attr('data-state-href', location.href);
        }
      });
    };


    var getA = 'a[data-remote]'
      , getForm = 'form[data-remote]';

    function getState(el) {
      // insert your own code here to extract a relevant state object from an <a> or <form> tag
      // for example, if you rely on any other custom "data-" attributes to determine the link behaviour
      return {};
    };

    $('body').attr('data-state-href', location.href);

    $('#search_results_container').on('ajax:beforeSend', getA, function(xhr) {
      pushPageState(getState(this), "Loading...", this.href);
      document.title = "Loading...";
    });

    $('#search_results_container').on('ajax:beforeSend', getForm, function(xhr) {
      var href = $(this).attr("action") + "?" + $(this).serialize();

      pushPageState(getState(this), 'Loading...', href);
      document.title = "Loading...";
    });

    // $('#search_results_container').on('ajax:complete', (getA + ',' + getForm), function(xhr) {
    //   $('body').attr('data-state-href', location.href);
    //   replacePageState(getState(this), window.title, location.href);
    // });
    // As of jQuery 1.8, the .ajaxComplete() method should only be attached to document.
    //   If you must differentiate between the requests, use the parameters passed to the handler.
    $(document).ajaxComplete(function(event, xhr, settings) {
      $('body').attr('data-state-href', location.href);
      document.title = "Directory > " + $(".search_filters .active a").html() + " > \"" + $('#q').val() + "\"";
      replacePageState(getState(this), document.title, location.href);
      window.scrollTo(0, 0);
    });
  }
});
