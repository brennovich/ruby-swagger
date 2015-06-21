require 'grape'
require 'ruby-swagger'
require 'ruby-swagger/grape/grape'
require_relative './application_entity'

class ApplicationsAPI < Grape::API

  version 'v1'
  format :json
  prefix :api

  def self.std_errors
    { '300' => {message:'Redirected', description: 'You will be redirected' },
      '404' => {message:'Not found', description: 'The document is nowhere to be found'},
      '501' => {message: 'WTF?', description: 'Shit happens'}
    }
  end

  def self.authentication_headers
    {
        'Authorization' => {
            description: "A valid user session token, in the format 'Bearer TOKEN'",
            required: true
        }
    }
  end

  default_headers authentication_headers

  resource :applications do

    api_desc 'Retrieves applications list' do
      detail 'This API does this and that and more'
      headers authentication_headers
      scopes 'application:read'
      tags 'applications'
      deprecated true
      hidden false
      api_name 'get_applications'
      result ApplicationEntity
      result_root 'applications'
      errors std_errors.merge("418" => {message: "I'm a teapot", description: "Yes, I am"})
    end
    params do
      optional :limit, type: Integer, desc: "Number of profiles returned. Default is 30 elements, max is 100 elements per page."
      optional :offset, type: Integer, desc: "Offset for pagination result. Use it combined with the limit field. Default is 0."
      optional :q, type: Hash do
        optional :service, type: String, desc: "Filter by application exposing a given service"
      end
    end
    get '/' do
      @applications = [
          {id: '123456', name: 'An app', description: 'Great App'},
          {id: '654321', name: 'Another app', description: 'Another great App'}
      ]
      api_present(@applications)
    end

    api_desc "Retrieves an application by its unique id or by its code name." do
      headers authentication_headers
      scopes 'application:read'
      tags %w(applications getter)
      deprecated true
      hidden true
      result ApplicationEntity
      result_root 'application'
      errors std_errors
    end
    params do
      requires :id, type: String, desc: "Unique identifier or code name of the application"
    end
    get '/:id' do
      @application = {id: '123456', name: 'An app', description: 'Great App'}
      api_present(@applications)
    end

    api_desc 'Check if the current user can access the given application' do
      headers authentication_headers
      scopes 'application:read'
      tags %w(applications getter)
      result Virtus::Attribute::Boolean
      result_root 'access'
    end
    params do
      requires :id, type: String, desc: 'Unique identifier or code name of the application'
    end
    get '/:id/check_access' do
      api_present true
    end

    api_desc "Install / buy the application by its unique id or by its code name." do
      headers authentication_headers
      scopes 'application:read'
      tags %w(applications create swag)
    end
    params do
      requires :id, type: String, desc: "Unique identifier or code name of the application"
    end
    post "/:id" do
      api_present true
    end

    # Mix in with desc instead of api_desc
    desc "Uninstall / unsubscribe an application by its unique id or by its code name."
    params do
      requires :id, type: String, desc: "Unique identifier or code name of the application"
    end
    delete "/:id" do
      present true
    end

  end

end