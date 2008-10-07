
class UploadManagerExtension < Radiant::Extension
  
  define_routes do |map|
	map.connect 'files/browse', :controller => 'file_upload', :action => 'browse'
    map.connect 'files/upload', :controller => 'file_upload', :action => 'upload'
	map.connect 'files/new_folder', :controller => 'file_upload', :action => 'new_folder'
	map.connect 'files/delete', :controller => 'file_upload', :action => 'destroy'
	map.connect 'admin/upload_manager', :controller => 'file_upload', :action => 'index'
  end

  def activate
	admin.tabs.add "Upload Manager", "/admin/upload_manager", :visibility => [:all]
  end
  
  def deactivate
    admin.tabs.remove "Upload Manager"
  end
end