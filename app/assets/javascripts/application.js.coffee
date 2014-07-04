#  biola-frontend-toolkit includes jquery, jquery_ujs, and bootstrap
#= require biola-frontend-toolkit
#= require_tree .



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
  closeAllCards()
  card.addClass('open')
  card.find('.details').slideDown()
  $('#backdrop').fadeIn()

$('#search_results').on 'click', '.result_card', (e) ->
  if $(this).hasClass('open')
    closeCard $(this), $(e.target)
  else
    openCard $(this), $(e.target)
  e.stopPropagation() # So body doesn't recieve the click

$('body').click (e) ->
  closeAllCards()
  $('#backdrop').fadeOut()
