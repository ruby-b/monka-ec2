module ApplicationHelper
  def active_class(path_name)
    request.original_fullpath.include?(path_name) ? 'active' : ""
  end
end
