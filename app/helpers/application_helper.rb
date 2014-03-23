module ApplicationHelper
  def current_project_tags
    Tag.all
  end

  def current_project_folders
    Folder.all
  end
end
