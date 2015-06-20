require 'grape'
require 'ruby-swagger'
require 'ruby-swagger/grape/grape'

class ApplicationsAPI < Grape::API

  version 'v1'
  format :json
  prefix :api

  def self.std_errors
    { '300' => 'Redirected',
      '404' => 'Not found',
      '501' => 'WTF?'
    }
  end

  default_user_authenticated true

  resource :applications do

    api_desc 'Retrieves applications list' do
      company_authenticated true
      scopes 'application:read'
      tags 'applications'
      deprecated true
      hidden true
      result ApplicationEntity
      result_root 'applications'
      errors std_errors.merge("418" => "I'm a teapot")
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

  end

end