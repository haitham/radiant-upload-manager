class FileUploadController < ApplicationController

  protect_from_forgery :except => [:upload, :new_folder, :destroy]
  skip_before_filter :authenticate
  skip_before_filter :set_current_user
  
  def upload
	unless params[:path] =~ /public/
		render :nothing, :status => :forbidden
		return false
	end
	file_name = params[:Filename]
	counter = 1
	while(true)
		begin
			open("#{params[:path]}/#{file_name}", "rb")
		rescue
			break
		end
		file_name = params[:Filename].reverse.sub('.', ".#{counter}_").reverse
		counter = counter + 1
	end
	open("#{params[:path]}/#{file_name}", "wb") do |f|
		f.write params[:Filedata].read
	end
	render :nothing => true
  end
  
  def index
	@dir = "#{RAILS_ROOT}/public/uploads"
	@save_to = "/public/uploads"
	@parent = "#{RAILS_ROOT}/public"
  end
  
  def browse
	unless params[:path] =~ /public/
		render :nothing, :status => :forbidden
		return false
	end
	@dir = params[:path]
	
	@save_to = @dir.split('/')
	i = 0
	while i < @save_to.length do
		if @save_to[i] == 'public'
			break
		end
		i = i + 1
	end
	@save_to = "/" + File.join( @save_to.last(@save_to.length - i) )
	
	@parent = @dir.split('/')
	@parent.pop
	@parent = @parent.join('/')
	
	render :update do |page|
		page.replace 'browse_dialog', :partial => 'browse'
	end
  end
  
  def new_folder
	unless params[:path] =~ /public/
		render :nothing, :status => :forbidden
		return false
	end
	
	error = false
	begin
		FileUtils.mkdir(File.join(params[:path], params[:folder_name]))
	rescue Exception => e
		render :update do |page|
			error = true
			page.call "alert", "an error occurred while creating the folder!!\nThe folder name might already exist"
		end
	end
	
	unless error
		render :update do |page|
			page.insert_html :top, 'dir_entries', :partial => 'directory', :locals => {:dir => params[:path], :filename => params[:folder_name]}
			page.visual_effect :highlight, "directory_#{params[:folder_name]}"
		end
	end
  end
  
  def destroy
	unless params[:path] =~ /public/
		render :nothing, :status => :forbidden
		return false
	end
	
	error = false
	begin
		FileUtils.remove_file( File.join(params[:path], params[:file]) )
	rescue Exception => e
		render :update do |page|
			error = true
			page.call "alert", "an error occurred while deleting this file!!"
		end
	end
	
	unless error
		render :update do |page|
			page.visual_effect :fade, "directory_#{params[:file]}", :afterFinish => "function(){$('directory_#{params[:file]}').remove();}"
		end
	end
  end
  
end

