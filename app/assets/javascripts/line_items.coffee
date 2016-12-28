# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# js
# var add_cart_item;

# add_cart_item = function(id) {
#   $.post('/line_items/' + id + '/add_cart_item');
#   return false;
# };

# coffee
@add_cart_item = (id) ->
  $.post '/line_items/' + id + '/add_cart_item'
  false
