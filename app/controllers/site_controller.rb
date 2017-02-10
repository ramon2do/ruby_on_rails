class SiteController < ApplicationController
	include UtilityHelper
	layout :set_layout

	before_filter :set_user_file

  	# Login View
  	def login
  		if session[:current_user_id]
  			redirect_to action: 'index', controller: 'contact'
  		else
  			
  		end
  	end

  	# Login by credentials
  	def signin
	  	email = params[:Signin][:email]
	  	password = params[:Signin][:password]

	  	file = @user_file
	  	user = nil
	  	
	  	if file_exists(file)
	  		user = get_user(file, email, password)
	  	end	
	  	

	  	if user && user != nil
	  		session[:current_user_id] = user
	  		redirect_to '/contacts'
	  	else
	  		flash[:danger] = 'Invalid Email / Password Combination'
      		redirect_to action: 'login'
      	end
  	end

  	# Register new user
  	def signup
  		id = '1';
	  	first_name = params[:Signup][:first_name]
	  	last_name = params[:Signup][:last_name]
	  	email = params[:Signup][:email]
	  	password = params[:Signup][:password]
	  	contents = []

	  	file = @user_file

	  	if !is_register(file, email)
	  		if file_exists(file)
	  			id = get_max_id_file(file)
	  			contents = JSON.parse(File.read(file))
	  		end

	  		content = {
	  			'id' => id.to_s,
	  			'first_name' => first_name,
	  			'last_name' => last_name,
	  			'email' => email,
	  			'password' => (Digest::MD5.hexdigest(password)).to_s
	  		} 

	  		contents.push(content)

			write_file(file, contents)
			flash[:success] = 'Register Success'
	  	else
	  		flash[:danger] = 'Email Exists ' + email
	  	end

		redirect_to action: 'login'
  	end

  	# Logout user
  	def logout
	    @_current_user = session[:current_user_id] = nil
	    redirect_to action: 'login'
  	end

  	# Set the layout by actions
  	private def set_layout
	    case action_name
	    when "login" 
	      "login"
	    when "signin"
	      "login"  
	    else
	      "application"
	    end
  	end

  	# Get user data by email and password
  	private def get_user(file, email, password)
  		data = File.read(file)
  		data_hash = JSON.parse(data)
  		user_data = nil

  		if !data_hash.empty?
  			data_hash.each do |user|
  			  if user != nil && user != '' && user != ' '
				  id_line_user = user['id']
				  first_name_line_user = user['first_name']
				  last_name_line_user = user['last_name']
				  email_line_user = user['email']
				  password_line_user = user['password']

				  if email_line_user == email && password_line_user.to_s == Digest::MD5.hexdigest(password)
				  	user_data = user
				  end	
  			  end
			end
  		end

  		return user_data
	end

	# Check if user exist with credentials
	private def auth_user(file, email, password)
  		data = read_file(file)
  		result = false

  		if !data.empty?
  			data.each do |user|
  			  if user != nil && user != '' && user != ' '
  			  	  line_user = user.split(';')	
				  email_line_user = line_user[3]
				  password_line_user = line_user[4]

				  if email_line_user == email && password_line_user.to_s == Digest::MD5.hexdigest(password)
				  	result = true
				  end	
  			  end
			end
  		end

  		return result
	end

	# Check if user exist by email
	private def is_register(file, email)
  		data = read_file(file)
  		result = false

  		if !data.empty?
  			data.each do |user|
  			  if user != nil && user != '' && user != ' '
  			  	  line_user = user.split(';')	
				  email_line_user = line_user[3]

				  if email_line_user == email
				  	result = true
				  end	
  			  end
			end
  		end	

  		return result
	end

	def set_user_file
  		@user_file = "db/data/users.json"
	end

end