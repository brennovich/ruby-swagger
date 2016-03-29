require 'grape'
require 'ruby-swagger'
require 'ruby-swagger/grape/grape'

require_relative './entities/errors'
require_relative './entities/application_entity'
require_relative './entities/status_detailed_entity'

require_relative './representers/status_representer'

class ApplicationsAPI < Grape::API
  version 'v1'
  format :json
  prefix :api

  def self.std_errors
    { '300' => { entity: ErrorRedirectEntity, description: 'You will be redirected' },
      '404' => { entity: ErrorNotFoundEntity, description: 'The document is nowhere to be found' },
      '501' => { entity: ErrorBoomEntity, description: 'Shit happens' }
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

  def self.result_headers
    {
      'X-Request-Id' => {
        description: 'Unique id of the API request',
        type: 'string'
      },
      'X-Runtime' => {
        description: 'Time spent processing the API request in ms',
        type: 'string'

      },
      'X-Rate-Limit-Limit' => {
        description: 'The number of allowed requests in the current period',
        type: 'integer'
      },
      'X-Rate-Limit-Remaining' => {
        description: 'The number of remaining requests in the current period',
        type: 'integer'
      },
      'X-Rate-Limit-Reset' => {
        description: 'The number of seconds left in the current period',
        type: 'integer'
      }
    }
  end

  default_headers authentication_headers
  default_response_headers result_headers

  resource :applications do
    api_desc 'Retrieves applications list' do
      detail 'This API does this and that and more'
      headers authentication_headers
      scopes 'application:read'
      tags 'applications'
      deprecated true
      hidden false
      api_name 'get_applications'
      response ApplicationEntity, root: 'applications', isArray: true, headers: result_headers
      errors std_errors.merge('418' => { entity: ErrorBoomEntity, description: 'Yes, I am a teapot' })
    end
    params do
      optional :limit, type: Integer, desc: 'Number of profiles returned. Default is 30 elements, max is 100 elements per page.'
      optional :offset, type: Integer, desc: 'Offset for pagination result. Use it combined with the limit field. Default is 0.'
      optional :q, type: Hash do
        optional :service, type: String, desc: 'Filter by application exposing a given service'
      end
    end
    get '/' do
      @applications = [
        { id: '123456', name: 'An app', description: 'Great App' },
        { id: '654321', name: 'Another app', description: 'Another great App' }
      ]

      api_present(@applications)
    end

    api_desc 'Retrieves an application by its unique id or by its code name.' do
      headers authentication_headers
      scopes 'application:read'
      tags %w(applications getter)
      deprecated true
      hidden true
      response ApplicationEntity, root: 'application', headers: result_headers
      errors std_errors
    end
    params do
      requires :id, type: String, desc: 'Unique identifier or code name of the application'
    end
    get '/:id' do
      @application = { id: '123456', name: 'An app', description: 'Great App' }
      api_present(@applications)
    end

    api_desc 'Check if the current user can access the given application' do
      headers authentication_headers
      scopes 'application:read'
      tags %w(applications getter)
      response ApplicationEntity, root: 'access'
    end
    params do
      requires :id, type: String, desc: 'Unique identifier or code name of the application'
    end
    get '/:id/check_access' do
      api_present true
    end

    api_desc 'Install / buy the application by its unique id or by its code name.' do
      headers authentication_headers
      scopes 'application:read'
      tags %w(applications create swag)
      api_name 'post_applications'
    end
    params do
      requires :id, type: String, desc: 'Unique identifier or code name of the application'
      requires :godzilla, type: Array, desc: 'Multiple options for this API'
      optional :simple, type: Integer, desc: 'A simple property', default: 'bazinga'
      requires :options, type: Array, desc: 'Multiple options for this API' do
        optional :me, type: String, desc: 'A property of the API'
        requires :other, type: Integer, desc: 'Another option'
        optional :list, type: Array, desc: 'A list of options' do
          optional :list_a, type: String, desc: 'List A'
          optional :list_b, type: Integer, desc: 'List B'
        end
      end
      optional :entry, type: Hash, desc: 'Another parameter, in hash' do
        optional :key_1, type: String, desc: 'Key one'
        optional :key_2, type: Hash, desc: 'Key two' do
          optional :key_3, type: String, desc: 'Sub one'
          optional :key_4, type: String, desc: 'Sub two'
        end
      end
    end
    post '/:id' do
      api_present true
    end

    api_desc 'Roar translation' do
      headers authentication_headers
      scopes %w(application:read application:write application:execute)
      tags %w(applications create swag more_swag)
      response StatusRepresenter, isArray: true, headers: result_headers
      api_name 'put_applications'
    end
    params do
      requires :id, type: String, desc: 'Unique identifier or code name of the application'
      requires :godzilla, type: Array, desc: 'Multiple options for this API'
    end
    put '/:id/roar' do
      @application = { id: '123456', name: 'An app', description: 'Great App' }
      api_present(@applications)
    end

    api_desc 'Deactivate an application.' do
      headers authentication_headers
      scopes %w(application:read application:write application:execute)
      tags %w(applications create swag more_swag)
      response StatusDetailedEntity, isArray: true, headers: result_headers
      api_name 'put_applications'
    end
    params do
      requires :id, type: String, desc: 'Unique identifier or code name of the application'
      requires :godzilla, type: Array, desc: 'Multiple options for this API'
    end
    put '/:id' do
      @application = { id: '123456', name: 'An app', description: 'Great App' }
      api_present(@applications)
    end

    # Mix in with desc instead of api_desc
    desc 'Uninstall / unsubscribe an application by its unique id or by its code name.'
    delete '/:id' do
      present true
    end
  end
end
