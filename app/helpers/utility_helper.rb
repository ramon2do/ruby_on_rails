module UtilityHelper

	private def write_file(file, content)
  		File.open(file, "w") do |f|
			f.write(JSON.generate(content))
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
  		data = File.read(file)
  		data_hash = JSON.parse(data)
  		max_id = 1

  		if !data_hash.empty?
  			data_hash.each do |line|
  			  if line != nil && line != '' && line != ' '
				  id_line = line['id']

				  if id_line && id_line != nil && id_line.to_i > 0
				  	max_id = (id_line.to_i + 1)
				  end	
  			  end
			end
  		end

  		return max_id
	end

	private def file_exists(file)
		if file != nil
  			File.exist?(file) || File.symlink?(file)
  		else
  			false	
  		end	
	end
end
