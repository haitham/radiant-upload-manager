namespace :radiant do
  namespace :extensions do
    namespace :upload_manager do
      
      desc "Copies public assets to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        Dir[UploadManagerExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(UploadManagerExtension.root, '')
          directory = File.dirname(path)
          puts "Copying #{path}..."
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
		begin
			FileUtils.mkdir "#{RAILS_ROOT}/public/uploads"
		rescue
		end
		begin
			FileUtils.mkdir "#{RAILS_ROOT}/public/uploads/File"
		rescue
		end
      end  
    end
  end
end
