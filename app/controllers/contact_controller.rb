class ContactController < ApplicationController
  include UtilityHelper	
  # layout "application"

  before_filter :set_contact_file

  # Index View
  def index
  	if session[:current_user_id]
  		@_current_user = session[:current_user_id]
      @_current_view = 'Contact List'
      @_contacts_view_active = 'active'
      @_contact_view_active = ''
  		user_id = @_current_user['id'].to_i

	  	file = @contact_file

	  	if user_id > 0
	  		if file_exists(file)
	  			@contacts = get_contacts(file, user_id)
	  		end
	  	end	

  	else
  		redirect_to action: 'login', controller: 'site'
  	end
  end

  # New View
  def create
    if session[:current_user_id]
      @_current_user = session[:current_user_id]
      @_current_view = 'New Contact'
      @_contacts_view_active = ''
      @_contact_view_active = 'active'
    else
      redirect_to action: 'login', controller: 'site'
    end
  end

  # Update View
  def update
    if session[:current_user_id]
      if params[:id]
        @_current_user = session[:current_user_id]
        @_current_view = 'Update Contact'
        @_contacts_view_active = 'active'
        @_contact_view_active = ''

        @_contact = nil
        file = @contact_file
        id = params[:id]

        if file_exists(file)
          @_contact = get_contact_by_id(file, id)
        end

        if @_contact == nil
          redirect_to action: 'index'
        end
      else  
        redirect_to action: 'index'
      end 
    else
      redirect_to action: 'login', controller: 'site'
    end
  end

  # Create New Contact
  def add
    if session[:current_user_id]
      @_current_user = session[:current_user_id]

      id = '1';
      first_name = params[:Contact][:first_name]
      last_name = params[:Contact][:last_name]
      email = params[:Contact][:email]
      telephone = params[:Contact][:telephone]
      contents = []
      user_id = @_current_user['id']

      file = @contact_file

      if file_exists(file)
        id = get_max_id_file(file)
        contents = JSON.parse(File.read(file))
      end

      content = {
        'id' => id.to_s,
        'first_name' => first_name,
        'last_name' => last_name,
        'email' => email,
        'telephone' => telephone,
        'user_id' => user_id.to_s
      }

      contents.push(content)

      write_file(file, contents)

      flash[:success] = 'Contact Save Success'

      redirect_to action: 'create'
    else
      redirect_to action: 'login', controller: 'site'
    end
  end

  # Update One Contact
  def change
    if session[:current_user_id]
      @_current_user = session[:current_user_id]

      id = params[:Contact][:id]
      first_name = params[:Contact][:first_name]
      last_name = params[:Contact][:last_name]
      email = params[:Contact][:email]
      telephone = params[:Contact][:telephone]
      contents = []

      file = @contact_file

      if file_exists(file)
        contents = JSON.parse(File.read(file))
      end

      content = {
        'id' => id.to_s,
        'first_name' => first_name,
        'last_name' => last_name,
        'email' => email,
        'telephone' => telephone
      }

      contents = update_contact_by_id(contents, content, id)

      write_file(file, contents)

      flash[:success] = 'Contact Update Success'

      redirect_to '/contact/' + id
    else
      redirect_to action: 'login', controller: 'site'
    end
  end

  # Delete View
  def delete
    if session[:current_user_id]
      if params[:id]
        @_current_user = session[:current_user_id]
        @_current_view = 'Delete Contact'
        @_contacts_view_active = 'active'
        @_contact_view_active = ''
        contents = []

        @_contact = nil
        file = @contact_file
        id = params[:id]

        if file_exists(file)
          contents = JSON.parse(File.read(file))
        end

        contents = delete_contact_by_id(contents, id)

        write_file(file, contents)

        flash[:success] = 'Contact Delete Success'

        redirect_to '/'
      else  
        redirect_to action: 'index'
      end 
    else
      redirect_to action: 'login', controller: 'site'
    end
  end

  # Get all contacts
  private def get_contacts(file, user_id)
      data = File.read(file)
      data_hash = JSON.parse(data)
      contacts_data = []

      if !data_hash.empty?
        data_hash.each do |contact|
          if contact != nil && contact != '' && contact != ' '
              user_id_line_contact = contact['user_id']

            if user_id_line_contact.to_s == user_id.to_s
              contacts_data.push contact
            end 
          end
        end
      end 

      return contacts_data
  end

  # Get one contact by id
  private def get_contact_by_id(file, id)
      data = File.read(file)
      data_hash = JSON.parse(data)
      contact_data = nil

      if !data_hash.empty?
        data_hash.each do |contact|
          if contact != nil && contact != '' && contact != ' '
              id_line_contact = contact['id']

            if id_line_contact.to_s == id.to_s
              contact_data = contact
            end 
          end
        end
      end 

      return contact_data
  end

  # Update one contact by id
  private def update_contact_by_id(contents, content, id)
      contacts_data = contents

      if !contacts_data.empty?
        contacts_data.each do |contact|
          if contact != nil && contact != '' && contact != ' '
              id_line_contact = contact['id']

            if id_line_contact.to_s == id.to_s
              contact['first_name'] = content['first_name']
              contact['last_name'] = content['last_name']
              contact['email'] = content['email']
              contact['telephone'] = content['telephone']
            end 
          end
        end
      end 

      return contacts_data
  end

  # Delete one contact by id
  private def delete_contact_by_id(contents, id)
      contacts_data = contents

      if !contacts_data.empty?
        contacts_data.each do |contact|
          if contact != nil && contact != '' && contact != ' '
              id_line_contact = contact['id']

            if id_line_contact.to_s == id.to_s
              contacts_data.delete(contact)
            end 
          end
        end
      end 

      return contacts_data
  end

  def set_contact_file
      @contact_file = "db/data/contacts.json"
  end
end