class FileUploadController < ApplicationController

  protect_from_forgery :except => [:upload]
  skip_before_filter :authenticate
  skip_before_filter :set_current_user
  
  def upload
	file_name = params[:Filename]
	counter = 1
	while(true)
		begin
			open("#{RAILS_ROOT}/public/uploads/File/#{file_name}", "rb")
		rescue
			break
		end
		file_name = params[:Filename].reverse.sub('.', ".#{counter}_").reverse
		counter = counter + 1
	end
	open("#{RAILS_ROOT}/public/uploads/File/#{file_name}", "wb") do |f|
		f.write params[:Filedata].read
	end
	render :nothing => true
  end
  
  def index
  end
  
end

