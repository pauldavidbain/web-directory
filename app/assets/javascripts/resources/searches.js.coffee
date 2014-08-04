if $("#search_results_container").length > 0

  closeAllCards = ->
    $('#search_results .result_card').each ->
      $(this).removeClass('open')
      $(this).find('.details').slideUp()
  closeCard = (card, target) ->
    unless target.parents('.details').length > 0 || target.is('.details')
      card.removeClass('open')
      card.find('.details').slideUp()
      $('#backdrop').fadeOut()
  openCard = (card, target) ->
    if card.data('profile-url')
      window.location = card.data('profile-url')
    else
      closeAllCards()
      card.addClass('open')
      card.find('.details').slideDown()
      $('#backdrop').fadeIn()

      # replace medium image with large image
      if medium_img = card.find('.result_image img').attr('src')
        card.find('.result_image img').attr('src', medium_img.replace('medium', 'large'))

  $('#search_results_container').on 'click', '.result_card', (e) ->
    if $(this).hasClass('open')
      closeCard $(this), $(e.target)
    else
      openCard $(this), $(e.target)
    e.stopPropagation() # So body doesn't recieve the click

  $('body').click (e) ->
    closeAllCards()
    $('#backdrop').fadeOut()
