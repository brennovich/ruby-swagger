require 'spec_helper'

require 'rake'
load "#{File.dirname(__FILE__)}/../../lib/tasks/swagger.rake"

require_relative '../fixtures/grape/applications_api'

describe 'Ruby::Swagger' do
  def no_stdout
    $stdout = StringIO.new
  end

  def open_yaml(file)
    YAML.load_file(file)
  end

  before do
    FileUtils.rm_rf('./doc/swagger')
  end

  after do
    FileUtils.rm_rf('./doc/swagger')
  end

  describe 'rake swagger:grape:generate_doc' do
    let(:rake_task) { Rake::Task['swagger:grape:generate_doc'] }

    before do
      rake_task.reenable
      no_stdout
      rake_task.invoke('ApplicationsAPI')
    end

    it 'should generate a base_doc.yml' do
      expect(File.exist?('./doc/swagger/base_doc.yml')).to be_truthy
    end

    it 'should generate a securityDefinitions.yml' do
      expect(File.exist?('./doc/swagger/securityDefinitions.yml')).to be_truthy
    end

    it 'base_doc.yml contains valid information' do
      base_doc = open_yaml './doc/swagger/base_doc.yml'
      expect(base_doc['swagger']).to eq '2.0'
      expect(base_doc['info']['title']).to eq 'My uber-duper API'
      expect(base_doc['info']['description']).to eq 'My uber-duper API description'
      expect(base_doc['info']['termsOfService']).to eq 'https://localhost/tos.html'

      expect(base_doc['info']['contact']['name']).to eq 'John Doe'
      expect(base_doc['info']['contact']['email']).to eq 'john.doe@example.com'
      expect(base_doc['info']['contact']['url']).to eq 'https://google.com/?q=john%20doe'

      expect(base_doc['info']['license']['name']).to eq 'Apache 2.0'
      expect(base_doc['info']['license']['url']).to eq 'http://www.apache.org/licenses/LICENSE-2.0.html'

      expect(base_doc['info']['version']).to eq '0.1'

      expect(base_doc['host']).to eq 'localhost:80'
      expect(base_doc['basePath']).to eq '/api/v1'
      expect(base_doc['schemes']).to eq %w(https http)
      expect(base_doc['consumes']).to eq ['application/json']
      expect(base_doc['produces']).to eq ['application/json']
    end

    it 'securityDefinitions.yml contains valid information' do
      base_doc = open_yaml './doc/swagger/securityDefinitions.yml'
      expect(base_doc['oauth2']).to eq({ 'type' => 'oauth2', 'flow' => 'accessCode', 'authorizationUrl' => 'https://', 'tokenUrl' => 'https://' })
    end

    it 'should generate a paths folder' do
      expect(Dir.exist?('./doc/swagger/paths')).to be_truthy
    end

    it 'should generate a scopes folder' do
      expect(Dir.exist?('./doc/swagger/scopes')).to be_truthy
    end

    it 'should generate a scopes oauth2 file' do
      expect(File.exist?('./doc/swagger/scopes/oauth2.yml')).to be_truthy
    end

    it 'oauth2.yml contains valid information' do
      scopes = open_yaml './doc/swagger/scopes/oauth2.yml'
      expect(scopes['application:read']).not_to be_nil
      expect(scopes['application:write']).not_to be_nil
      expect(scopes['application:execute']).not_to be_nil
    end

    it 'should generate a ./doc/swagger/paths/applications/get.yml file' do
      expect(File.exist?('./doc/swagger/paths/applications/get.yml')).to be_truthy
    end

    # the endpoint is hidden - nothing to see here
    it 'should NOT generate a ./doc/swagger/paths/applications/{id}/get.yml file' do
      expect(File.exist?('./doc/swagger/paths/applications/{id}/get.yml')).to be_falsey
    end

    it 'should generate a ./doc/swagger/paths/applications/{id}/post.yml file' do
      expect(File.exist?('./doc/swagger/paths/applications/{id}/post.yml')).to be_truthy
    end

    it 'should generate a ./doc/swagger/paths/applications/{id}/delete.yml file' do
      expect(File.exist?('./doc/swagger/paths/applications/{id}/delete.yml')).to be_truthy
    end

    it 'should generate a ./doc/swagger/paths/applications/{id}/check_access/get.yml file' do
      expect(File.exist?('./doc/swagger/paths/applications/{id}/check_access/get.yml')).to be_truthy
    end

    describe 'deprecation' do
      it 'should include information about deprecation in applications/get.yml' do
        expect(open_yaml('./doc/swagger/paths/applications/get.yml')['deprecated']).to be_truthy
      end
    end

    describe 'tags' do
      it 'should include tags information in applications/get.yml' do
        expect(open_yaml('./doc/swagger/paths/applications/get.yml')['tags']).to eq(['applications'])
      end

      it 'should include tags information in applications/{id}/check_access/get.yml' do
        expect(open_yaml('./doc/swagger/paths/applications/{id}/check_access/get.yml')['tags']).to eq(%w(applications getter))
      end

      it 'should include tags information in applications/{id}/post.yml' do
        expect(open_yaml('./doc/swagger/paths/applications/{id}/post.yml')['tags']).to eq(%w(applications create swag))
      end
    end

    describe 'documentation description' do
      it 'should include a summary and a detail in applications/get.yml' do
        expect(open_yaml('./doc/swagger/paths/applications/get.yml')['summary']).to eq 'Retrieves applications list'
        expect(open_yaml('./doc/swagger/paths/applications/get.yml')['description']).to eq 'This API does this and that and more'
      end

      it 'should include a summary and a detail in applications/{id}/post.yml' do
        expect(open_yaml('./doc/swagger/paths/applications/{id}/post.yml')['summary']).to eq 'Install / buy the application by its unique id or by its code name.'
        expect(open_yaml('./doc/swagger/paths/applications/{id}/post.yml')['description']).to eq 'Install / buy the application by its unique id or by its code name.'
      end

      it 'should include a summary and a detail in applications/{id}/delete.yml' do
        expect(open_yaml('./doc/swagger/paths/applications/{id}/delete.yml')['summary']).to eq 'Uninstall / unsubscribe an application by its unique id or by its code name.'
        expect(open_yaml('./doc/swagger/paths/applications/{id}/delete.yml')['description']).to eq 'Uninstall / unsubscribe an application by its unique id or by its code name.'
      end
    end

    describe 'operationId' do
      it 'should include an operationId in applications/{id}/check_access/get.yml' do
        expect(open_yaml('./doc/swagger/paths/applications/get.yml')['operationId']).to eq 'get_applications'
      end

      it 'should include an operationId in applications/{id}/check_access/post.yml' do
        expect(open_yaml('./doc/swagger/paths/applications/{id}/post.yml')['operationId']).to eq 'post_applications'
      end

      it 'should include an operationId in applications/{id}/check_access/put.yml' do
        expect(open_yaml('./doc/swagger/paths/applications/{id}/put.yml')['operationId']).to eq 'put_applications'
      end
    end

    describe 'params' do
      it 'should get parameters for applications/{id}/check_access/get.yml' do
        doc = open_yaml('./doc/swagger/paths/applications/{id}/check_access/get.yml')

        expect(doc['parameters'].count).to eq 2

        expect(doc['parameters'][0]['name']).to eq 'Authorization'
        expect(doc['parameters'][0]['in']).to eq 'header'
        expect(doc['parameters'][0]['description']).to eq 'A valid user session token, in the format \'Bearer TOKEN\''
        expect(doc['parameters'][0]['type']).to eq 'string'
        expect(doc['parameters'][0]['required']).to be_truthy

        expect(doc['parameters'][1]['name']).to eq 'id'
        expect(doc['parameters'][1]['in']).to eq 'path'
        expect(doc['parameters'][1]['required']).to be_truthy
        expect(doc['parameters'][1]['type']).to eq 'string'
      end

      it 'should get parameters for applications/get.yml' do
        doc = open_yaml('./doc/swagger/paths/applications/get.yml')

        expect(doc['parameters'].count).to eq 4

        expect(doc['parameters'][0]['name']).to eq 'Authorization'
        expect(doc['parameters'][0]['in']).to eq 'header'
        expect(doc['parameters'][0]['description']).to eq 'A valid user session token, in the format \'Bearer TOKEN\''
        expect(doc['parameters'][0]['type']).to eq 'string'
        expect(doc['parameters'][0]['required']).to be_truthy

        expect(doc['parameters'][1]['name']).to eq 'limit'
        expect(doc['parameters'][1]['in']).to eq 'query'
        expect(doc['parameters'][1]['description']).to eq 'Number of profiles returned. Default is 30 elements, max is 100 elements per page.'
        expect(doc['parameters'][1]['type']).to eq 'integer'
        expect(doc['parameters'][1]['required']).to eq false

        expect(doc['parameters'][2]['name']).to eq 'offset'
        expect(doc['parameters'][2]['in']).to eq 'query'
        expect(doc['parameters'][2]['description']).to eq 'Offset for pagination result. Use it combined with the limit field. Default is 0.'
        expect(doc['parameters'][2]['type']).to eq 'integer'
        expect(doc['parameters'][2]['required']).to eq false

        expect(doc['parameters'][3]['name']).to eq 'q[service]'
        expect(doc['parameters'][3]['in']).to eq 'query'
        expect(doc['parameters'][3]['description']).to eq 'Filter by application exposing a given service'
        expect(doc['parameters'][3]['type']).to eq 'string'
        expect(doc['parameters'][3]['required']).to eq false
      end

      it 'should get parameters for applications/post.yml' do
        doc = open_yaml('./doc/swagger/paths/applications/{id}/post.yml')

        expect(doc['parameters'].count).to eq 3

        expect(doc['parameters'][0]['name']).to eq 'Authorization'
        expect(doc['parameters'][0]['in']).to eq 'header'
        expect(doc['parameters'][0]['description']).to eq 'A valid user session token, in the format \'Bearer TOKEN\''
        expect(doc['parameters'][0]['type']).to eq 'string'
        expect(doc['parameters'][0]['required']).to be_truthy

        expect(doc['parameters'][1]['name']).to eq 'id'
        expect(doc['parameters'][1]['in']).to eq 'path'
        expect(doc['parameters'][1]['type']).to eq 'string'
        expect(doc['parameters'][1]['required']).to be_truthy

        expect(doc['parameters'][2]['name']).to eq 'post_applications_body'
        expect(doc['parameters'][2]['in']).to eq 'body'
        expect(doc['parameters'][2]['description']).to eq 'the content of the request'
        expect(doc['parameters'][2]['schema']).not_to be_nil

        expect(doc['parameters'][2]['schema']['required']).to eq %w(godzilla options)
        expect(doc['parameters'][2]['schema']['type']).to eq 'object'

        expect(doc['parameters'][2]['schema']['properties']['godzilla']['type']).to eq 'array'
        expect(doc['parameters'][2]['schema']['properties']['godzilla']['description']).to eq 'Multiple options for this API'
        expect(doc['parameters'][2]['schema']['properties']['godzilla']['items']['type']).to eq 'string'

        expect(doc['parameters'][2]['schema']['properties']['simple']['type']).to eq 'integer'
        expect(doc['parameters'][2]['schema']['properties']['simple']['description']).to eq 'A simple property'
        expect(doc['parameters'][2]['schema']['properties']['simple']['default']).to eq 'bazinga'

        expect(doc['parameters'][2]['schema']['properties']['options']['type']).to eq 'array'
        expect(doc['parameters'][2]['schema']['properties']['options']['description']).to eq 'Multiple options for this API'
        expect(doc['parameters'][2]['schema']['properties']['options']['items']['type']).to eq 'object'
        expect(doc['parameters'][2]['schema']['properties']['options']['items']['required']).to eq %w(other)

        expect(doc['parameters'][2]['schema']['properties']['options']['items']['properties']['me']['description']).to eq 'A property of the API'
        expect(doc['parameters'][2]['schema']['properties']['options']['items']['properties']['me']['type']).to eq 'string'

        expect(doc['parameters'][2]['schema']['properties']['options']['items']['properties']['other']['description']).to eq 'Another option'
        expect(doc['parameters'][2]['schema']['properties']['options']['items']['properties']['other']['type']).to eq 'integer'

        expect(doc['parameters'][2]['schema']['properties']['options']['items']['properties']['list']['description']).to eq 'A list of options'
        expect(doc['parameters'][2]['schema']['properties']['options']['items']['properties']['list']['type']).to eq 'array'
        expect(doc['parameters'][2]['schema']['properties']['options']['items']['properties']['list']['items']['type']).to eq 'object'

        expect(doc['parameters'][2]['schema']['properties']['options']['items']['properties']['list']['items']['properties']['list_a']['description']).to eq 'List A'
        expect(doc['parameters'][2]['schema']['properties']['options']['items']['properties']['list']['items']['properties']['list_a']['type']).to eq 'string'

        expect(doc['parameters'][2]['schema']['properties']['options']['items']['properties']['list']['items']['properties']['list_b']['description']).to eq 'List B'
        expect(doc['parameters'][2]['schema']['properties']['options']['items']['properties']['list']['items']['properties']['list_b']['type']).to eq 'integer'

        expect(doc['parameters'][2]['schema']['properties']['entry']['description']).to eq 'Another parameter, in hash'
        expect(doc['parameters'][2]['schema']['properties']['entry']['type']).to eq 'object'

        expect(doc['parameters'][2]['schema']['properties']['entry']['properties']['key_1']['description']).to eq 'Key one'
        expect(doc['parameters'][2]['schema']['properties']['entry']['properties']['key_1']['type']).to eq 'string'

        expect(doc['parameters'][2]['schema']['properties']['entry']['properties']['key_2']['description']).to eq 'Key two'
        expect(doc['parameters'][2]['schema']['properties']['entry']['properties']['key_2']['type']).to eq 'object'

        expect(doc['parameters'][2]['schema']['properties']['entry']['properties']['key_2']['properties']['key_3']['description']).to eq 'Sub one'
        expect(doc['parameters'][2]['schema']['properties']['entry']['properties']['key_2']['properties']['key_3']['type']).to eq 'string'

        expect(doc['parameters'][2]['schema']['properties']['entry']['properties']['key_2']['properties']['key_4']['description']).to eq 'Sub two'
        expect(doc['parameters'][2]['schema']['properties']['entry']['properties']['key_2']['properties']['key_4']['type']).to eq 'string'
      end

      it 'should get parameters for applications/{id}/delete.yml' do
        doc = open_yaml('./doc/swagger/paths/applications/{id}/delete.yml')

        expect(doc['parameters'].count).to eq 1

        expect(doc['parameters'][0]['name']).to eq 'id'
        expect(doc['parameters'][0]['in']).to eq 'path'
        expect(doc['parameters'][0]['description']).to be_nil
        expect(doc['parameters'][0]['type']).to eq 'string'
        expect(doc['parameters'][0]['required']).to be_truthy
      end
    end

    describe 'response' do
      it 'should include a response applications/{id}/check_access/get.yml' do
        doc = open_yaml('./doc/swagger/paths/applications/{id}/check_access/get.yml')

        expect(doc['responses'].keys.count).to eq 2

        expect(doc['responses']['200']['description']).to eq 'Successful result of the operation'
        expect(doc['responses']['200']['schema']).to eq({ 'type' => 'object', 'properties' => { 'access' => { 'type' => 'object', '$ref' => '#/definitions/ApplicationEntity' } } })

        expect(doc['responses']['default']['description']).to eq 'Unexpected error'
      end

      it 'should include a response for applications/get.yml' do
        doc = open_yaml('./doc/swagger/paths/applications/get.yml')

        expect(doc['responses'].keys.count).to eq 6

        expect(doc['responses']['200']['description']).to eq 'Successful result of the operation'
        expect(doc['responses']['200']['schema']).to eq({ 'type' => 'object', 'properties' => { 'applications' => { 'type' => 'array', 'items' => { 'type' => 'object', '$ref' => '#/definitions/ApplicationEntity' } } } })
        expect(doc['responses']['200']['headers']).to eq({ 'X-Request-Id' => { 'description' => 'Unique id of the API request', 'type' => 'string' },
                                                           'X-Runtime' => { 'description' => 'Time spent processing the API request in ms', 'type' => 'string' },
                                                           'X-Rate-Limit-Limit' => { 'description' => 'The number of allowed requests in the current period', 'type' => 'integer' },
                                                           'X-Rate-Limit-Remaining' => { 'description' => 'The number of remaining requests in the current period', 'type' => 'integer' },
                                                           'X-Rate-Limit-Reset' => { 'description' => 'The number of seconds left in the current period', 'type' => 'integer' } })

        expect(doc['responses']['300']['description']).to eq 'You will be redirected'
        expect(doc['responses']['300']['schema']).to eq({ '$ref' => '#/definitions/ErrorRedirectEntity' })

        expect(doc['responses']['404']['description']).to eq 'The document is nowhere to be found'
        expect(doc['responses']['404']['schema']).to eq({ '$ref' => '#/definitions/ErrorNotFoundEntity' })

        expect(doc['responses']['501']['description']).to eq 'Shit happens'
        expect(doc['responses']['501']['schema']).to eq({ '$ref' => '#/definitions/ErrorBoomEntity' })

        expect(doc['responses']['418']['description']).to eq 'Yes, I am a teapot'
        expect(doc['responses']['418']['schema']).to eq({ '$ref' => '#/definitions/ErrorBoomEntity' })

        expect(doc['responses']['default']['description']).to eq 'Unexpected error'
      end

      it 'should include a response for applications/{id}/post.yml' do
        doc = open_yaml('./doc/swagger/paths/applications/{id}/post.yml')

        expect(doc['responses'].keys.count).to eq 1

        expect(doc['responses']['default']['description']).to eq 'Unexpected error'
      end

      it 'should get parameters for applications/{id}/delete.yml' do
        doc = open_yaml('./doc/swagger/paths/applications/{id}/delete.yml')

        expect(doc['responses'].keys.count).to eq 1

        expect(doc['responses']['default']['description']).to eq 'Unexpected error'
      end
    end

    describe 'definitions' do
      it 'should create a definition file ApplicationEntity.yml' do
        doc = open_yaml('./doc/swagger/definitions/ApplicationEntity.yml')

        expect(doc).to eq({ 'type' => 'object',
                            'properties' => {
                              'id' => { 'type' => 'string', 'description' => 'unique ID' },
                              'free' => { 'type' => 'boolean', 'description' => 'True if application is free' },
                              'name' => { 'type' => 'string', 'description' => 'Human readable application name' },
                              'description' => { 'type' => 'string', 'description' => 'Application description' },
                              'pictures' => { 'type' => 'array', 'items' => { 'type' => 'object', '$ref' => '#/definitions/ImageEntity' }, 'description' => 'Application pictures' } } }
                         )
      end

      it 'should create a definition file ErrorBoomEntity.yml' do
        doc = open_yaml('./doc/swagger/definitions/ErrorBoomEntity.yml')

        expect(doc).to eq({ 'type' => 'object',
                            'properties' => {
                              'errors' => { 'type' => 'array', 'items' => { 'type' => 'string' },
                                            'description' => 'errors produced by this method' },
                              'message' => { 'type' => 'string', 'description' => 'Why? Why? Why????' } } }
                         )
      end

      it 'should create a definition file ErrorNotFoundEntity.yml' do
        doc = open_yaml('./doc/swagger/definitions/ErrorNotFoundEntity.yml')

        expect(doc).to eq({ 'type' => 'object',
                            'properties' => {
                              'errors' => { 'type' => 'array', 'items' => { 'type' => 'string' },
                                            'description' => 'errors produced by this method' },
                              'message' => { 'type' => 'string', 'description' => 'Why? Why? Why????' } } }
                         )
      end

      it 'should create a definition file ErrorRedirectEntity.yml' do
        doc = open_yaml('./doc/swagger/definitions/ErrorRedirectEntity.yml')

        expect(doc).to eq({ 'type' => 'object',
                            'properties' => {
                              'errors' => { 'type' => 'array', 'items' => { 'type' => 'string' },
                                            'description' => 'errors produced by this method' },
                              'message' => { 'type' => 'string', 'description' => 'Why? Why? Why????' } } }
                         )
      end

      it 'should create a definition file ImageEntity.yml' do
        doc = open_yaml('./doc/swagger/definitions/ImageEntity.yml')

        expect(doc).to eq({ 'type' => 'object',
                            'properties' => {
                              'url' => { 'type' => 'string', 'description' => 'The url of the image' },
                              'name' => { 'type' => 'string', 'description' => 'The name of the image' },
                              'size' => { 'type' => 'integer', 'description' => 'Size of the picture' } } }
                         )
      end

      it 'should create a definition file StatusDetailedEntity.yml' do
        doc = open_yaml('./doc/swagger/definitions/StatusDetailedEntity.yml')

        expect(doc).to eq({ 'type' => 'object',
                            'properties' => {
                              'user_name' => { 'type' => 'string' },
                              'text' => { 'type' => 'string', 'description' => 'Status update text.' },
                              'ip' => { 'type' => 'string' }, 'user_type' => { 'type' => 'string' },
                              'user_id' => { 'type' => 'string' },
                              'contact_info' => { 'type' => 'object',
                                                  'properties' => { 'phone' => { 'type' => 'string' },
                                                                    'address' => { 'type' => 'object', '$ref' => '#/definitions/ImageEntity' } } },
                              'digest' => { 'type' => 'string' },
                              'responses' => { 'type' => 'object', '$ref' => '#/definitions/StatusEntity' },
                              'last_reply' => { 'type' => 'object', '$ref' => '#/definitions/StatusEntity' },
                              'list' => { 'type' => 'array',
                                          'items' => { 'type' => 'object',
                                                       'properties' => {
                                                         'option_a' => { 'type' => 'object',
                                                                         'properties' => {
                                                                           'option_b' => { 'type' => 'array',
                                                                                           'items' => { 'type' => 'string' }, 'description' => 'An option' } } },
                                                         'option_c' => { 'type' => 'integer', 'description' => 'Last option' } } }, 'description' => 'List of elements' },
                              'created_at' => { 'type' => 'string' },
                              'updated_at' => { 'type' => 'string' },
                              'internal_id' => { 'type' => 'string' } } }
                         )
      end

      it 'should create a definition file StatusEntity.yml' do
        doc = open_yaml('./doc/swagger/definitions/StatusEntity.yml')

        expect(doc).to eq({ 'type' => 'object',
                            'properties' => {
                              'user_name' => { 'type' => 'string' },
                              'text' => { 'type' => 'string', 'description' => 'Status update text.' },
                              'ip' => { 'type' => 'string' }, 'user_type' => { 'type' => 'string' },
                              'user_id' => { 'type' => 'string' },
                              'contact_info' => { 'type' => 'object',
                                                  'properties' => { 'phone' => { 'type' => 'string' },
                                                                    'address' => { 'type' => 'object', '$ref' => '#/definitions/ImageEntity' } } },
                              'digest' => { 'type' => 'string' },
                              'responses' => { 'type' => 'object', '$ref' => '#/definitions/StatusEntity' },
                              'last_reply' => { 'type' => 'object', '$ref' => '#/definitions/StatusEntity' },
                              'list' => { 'type' => 'array',
                                          'items' => { 'type' => 'object',
                                                       'properties' => {
                                                         'option_a' => { 'type' => 'object',
                                                                         'properties' => {
                                                                           'option_b' => { 'type' => 'array',
                                                                                           'items' => { 'type' => 'string' }, 'description' => 'An option' } } },
                                                         'option_c' => { 'type' => 'integer', 'description' => 'Last option' } } }, 'description' => 'List of elements' },
                              'created_at' => { 'type' => 'string' },
                              'updated_at' => { 'type' => 'string' } } }
                         )
      end
    end

    it 'should create a definition file StatusRepresenter.yml' do
      doc = open_yaml('./doc/swagger/definitions/StatusRepresenter.yml')

      expect(doc).to eq({ 'type' => 'object',
                          'properties' => {
        'user_name' => { 'type' => 'string' },
        'text' => { 'type' => 'string', 'description' => 'Status update text.' },
        'ip' => { 'type' => 'string' }, 'user_type' => { 'type' => 'string' },
        'user_id' => { 'type' => 'string' },
        'contact_info' => { 'type' => 'object',
                            'properties' => { 'phone' => { 'type' => 'string' },
                                              'address' => { 'type' => 'object', '$ref' => '#/definitions/ImageRepresenter' } } },
        'digest' => { 'type' => 'string' },
        'responses' => { 'type' => 'object', '$ref' => '#/definitions/StatusRepresenter' },
        'last_reply' => { 'type' => 'object', '$ref' => '#/definitions/StatusRepresenter' },
        'list' => { 'type' => 'array',
                    'items' => { 'type' => 'object',
                                 'properties' => {
                      'option_a' => { 'type' => 'object',
                                      'properties' => {
                        'option_b' => { 'type' => 'array',
                                        'items' => { 'type' => 'string' }, 'description' => 'An option' } } },
                      'option_c' => { 'type' => 'integer', 'description' => 'Last option' } } }, 'description' => 'List of elements' },
        'created_at' => { 'type' => 'string' },
        'updated_at' => { 'type' => 'string' } } }
                       )
    end
  end
end
