if $('#memberships_filters').length > 0
  $('#memberships_container').mixItUp
    animation:
      enable: false
    callbacks:
      onMixEnd: (state) ->
        # Hide objects after they get hidden. You could set this by default in css, but we are doing it here for various reasons.
        state.$hide.css('display', 'none')


