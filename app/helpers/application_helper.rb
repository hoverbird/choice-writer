module ApplicationHelper
  def current_project_tags
    Tag.all
  end
end
