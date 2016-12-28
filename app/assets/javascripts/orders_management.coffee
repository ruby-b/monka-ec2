# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@async_confirm_payment = (elm, id) ->
  $(elm).addClass('disabled').html '処理中です...'
  $.post '/orders_management/' + id + '/async_confirm_payment'
  false

@async_deliver = (elm, id) ->
  $(elm).addClass('disabled').html '処理中です...'
  $.post '/orders_management/' + id + '/async_deliver'
  false

