class ContactController < ApplicationController
  include UtilityHelper	
  layout "application"

  def index
  	if session[:current_user_id]
  		@_current_user = session[:current_user_id]

  		user_id = 0

	  	@_current_user.each do |attr|
	  		if attr[0] == 'id'
	  			user_id = attr[1].to_i
	  		end
  		end

	  	file = "D:/Respaldo_Unidad_C/ruby/projects/conectium/app/assets/files/contacts.txt"

	  	if user_id > 0
	  		if file_exists(file)
	  			@contacts = get_contacts(file, user_id)
	  		end
	  	end	

  	else
  		redirect_to action: 'login', controller: 'site'
  	end
  end

  def new
  	if session[:current_user_id]
  		@_current_user = session[:current_user_id]
  	else
  		redirect_to action: 'login', controller: 'site'
  	end
  end

  def add
  	if session[:current_user_id]
  		@_current_user = session[:current_user_id]

  		id = '1';
  		first_name = params[:Contact][:first_name]
	  	last_name = params[:Contact][:last_name]
	  	email = params[:Contact][:email]
	  	telephone = params[:Contact][:telephone]
	  	user_id = 0

	  	@_current_user.each do |attr|
	  		if attr[0] == 'id'
	  			user_id = attr[1]
	  		end
  		end

	  	file = "D:/Respaldo_Unidad_C/ruby/projects/conectium/app/assets/files/contacts.txt"

	  	if file_exists(file)
	  		id = get_max_id_file(file)
	  	end

	  	content = id.to_s + ';' + first_name + ';' + last_name + ';' + email + ';' + telephone + ';' + user_id.to_s
		write_file(file, content)

		flash[:success] = 'Contact Save Success'

		redirect_to action: 'new'
  	else
  		redirect_to action: 'login', controller: 'site'
  	end
  end

  private def get_contacts(file, user_id)
  		data = read_file(file)
  		contacts_data = []

  		if !data.empty?
  			data.each do |contact|
  			  if contact != nil && contact != '' && contact != ' '
  			  	  line_contact = contact.split(';')	
				  id_line_contact = line_contact[0]
				  first_name_line_contact = line_contact[1]
				  last_name_line_contact = line_contact[2]
				  email_line_contact = line_contact[3]
				  telephone_line_contact = line_contact[4]
				  user_id_line_contact = line_contact[5]

				  if user_id_line_contact.to_s == user_id.to_s
				  	contacts_data.push line_contact
				  end	
  			  end
			end
  		end	

  		return contacts_data
	end
end
