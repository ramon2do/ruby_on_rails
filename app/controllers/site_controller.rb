class SiteController < ApplicationController
	include UtilityHelper
	layout :set_layout

	# Index View
  	def index
  		if session[:current_user_id]
  			@_current_user = session[:current_user_id]
  		else
  			redirect_to action: 'login'
  		end
  	end

  	# Login View
  	def login
  		if session[:current_user_id]
  			redirect_to action: 'index'
  		else
  			
  		end
  	end

  	# Login by credentials
  	def signin
	  	email = params[:Signin][:email]
	  	password = params[:Signin][:password]

	  	file = "D:/Respaldo_Unidad_C/ruby/projects/conectium/app/assets/files/users.txt"
	  	user = get_user(file, email, password)

	  	if user && user != nil
	  		session[:current_user_id] = user
	  		redirect_to action: 'index'
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

	  	file = "D:/Respaldo_Unidad_C/ruby/projects/conectium/app/assets/files/users.txt"

	  	if !is_register(file, email)
	  		if file_exists(file)
	  			id = get_max_id_file(file)
	  		end

	  		content = id.to_s + ';' + first_name + ';' + last_name + ';' + email + ';' + Digest::MD5.hexdigest(password) 
			write_file(file, content)
			flash[:success] = 'Register Success'
	  	else
	  		flash[:danger] = 'Email Exists ' + email
	  	end

		redirect_to action: 'login'
  	end

  	# Logout user
  	def logout
	    @_current_user = session[:current_user_id] = nil
	    redirect_to action: 'index'
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

  	private def get_user(file, email, password)
  		data = read_file(file)
  		user_data = nil

  		if !data.empty?
  			data.each do |user|
  			  if user != nil && user != '' && user != ' '
  			  	  line_user = user.split(';')	
				  id_line_user = line_user[0]
				  first_name_line_user = line_user[1]
				  last_name_line_user = line_user[2]
				  email_line_user = line_user[3]
				  password_line_user = line_user[4]

				  if email_line_user == email && password_line_user.to_s == Digest::MD5.hexdigest(password)
				  	user_data = {
				  					id: id_line_user, 
				  					first_name: first_name_line_user, 
				  					last_name: last_name_line_user,
				  					email: email_line_user
				  				}
				  end	
  			  end
			end
  		end

  		return user_data
	end

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

end
