module UtilityHelper

	private def write_file(file, content)
  		if file_exists(file)
	   		File.open(file, "a") do |f|
			  f.puts content
			end
		else 
			File.open(file, "w+") do |f|
			  f.puts content
			end	
		end
	end

	private def read_file(file)
		data = []
  		if file_exists(file)
	   		File.open(file, "r").each_line do |line|
	   		  line_format = line.sub(/\n/, '')
			  data.push line_format		
			end
		end

		return data
	end

	private def get_max_id_file(file)
		data = []
  		if file_exists(file)
	   		File.open(file, "r").each_line do |line|
	   		  line_format = line.sub(/\n/, '')
			  data.push line_format		
			end
		end

		return data
	end

	private def get_max_id_file(file)
  		data = read_file(file)
  		max_id = 1

  		if !data.empty?
  			data.each do |line|
  			  if line != nil && line != '' && line != ' '
  			  	  line_user = line.split(';')	
				  id_line = line_user[0]

				  if id_line && id_line != nil && id_line.to_i > 0
				  	max_id = id_line.to_i + 1
				  end	
  			  end
			end
  		end

  		return max_id
	end

	private def file_exists(file)
  		File.exist?(file) || File.symlink?(file)
	end
end
