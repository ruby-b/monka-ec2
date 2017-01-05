module ApplicationHelper
  def active_class(path_name)
    request.original_fullpath.include?(path_name) ? 'active' : ""
  end
  
  def cart_status_link(cart = nil)
    return if cart.blank?
    count = number_to_currency(cart.try(:total_number), precision: 0, unit: "個")
    price = number_to_currency(cart.try(:total_price), precision: 0, unit: "円")
    link_name = "カート(#{count} #{price})"
    link_to(link_name, cart_path(cart))
  end
end
