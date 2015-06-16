require 'spec_helper'
require 'yaml'
require 'ruby-swagger/data/security_definitions'

describe Swagger::Data::SecurityDefinitions do

    let(:payload) do
      {
          "api_key"=> {
            "type"=> "apiKey",
            "name"=> "api_key",
            "in"=> "header"
          },
          "petstore_auth"=> {
            "type"=> "oauth2",
            "authorizationUrl"=> "http://swagger.io/api/oauth/dialog",
            "flow"=> "implicit",
            "scopes"=> {
              "write:pets"=> "modify pets in your account",
              "read:pets"=> "read your pets"
            }
          }
      }
    end

    context 'when parsing' do
      it 'should create a valid Swagger::Data::SecurityDefinitions' do
        parsed = Swagger::Data::SecurityDefinitions.parse(payload)

        expect(parsed['api_key'].type).to eq 'apiKey'
        expect(parsed['api_key'].name).to eq 'api_key'
        expect(parsed['api_key'].in).to eq 'header'

        expect(parsed['petstore_auth'].type).to eq 'oauth2'
        expect(parsed['petstore_auth'].authorizationUrl).to eq 'http://swagger.io/api/oauth/dialog'
        expect(parsed['petstore_auth'].flow).to eq 'implicit'
        expect(parsed['petstore_auth'].scopes["write:pets"]).to eq "modify pets in your account"
        expect(parsed['petstore_auth'].scopes["read:pets"]).to eq "read your pets"
      end
    end


    context 'when creating the object' do
      let(:object) do
        Swagger::Data::SecurityDefinitions.parse(payload)
      end

      it 'should convert it to a valid JSON' do
        parsed = OpenStruct.new JSON.parse(object.to_json)

        expect(parsed['api_key']['type']).to eq 'apiKey'
        expect(parsed['api_key']['name']).to eq 'api_key'
        expect(parsed['api_key']['in']).to eq 'header'

        expect(parsed['petstore_auth']['type']).to eq 'oauth2'
        expect(parsed['petstore_auth']['authorizationUrl']).to eq 'http://swagger.io/api/oauth/dialog'
        expect(parsed['petstore_auth']['flow']).to eq 'implicit'
        expect(parsed['petstore_auth']['scopes']["write:pets"]).to eq "modify pets in your account"
        expect(parsed['petstore_auth']['scopes']["read:pets"]).to eq "read your pets"
      end

      it 'should convert it to a valid YAML' do
        parsed = OpenStruct.new YAML.load(object.to_yaml)

        expect(parsed['api_key']['type']).to eq 'apiKey'
        expect(parsed['api_key']['name']).to eq 'api_key'
        expect(parsed['api_key']['in']).to eq 'header'

        expect(parsed['petstore_auth']['type']).to eq 'oauth2'
        expect(parsed['petstore_auth']['authorizationUrl']).to eq 'http://swagger.io/api/oauth/dialog'
        expect(parsed['petstore_auth']['flow']).to eq 'implicit'
        expect(parsed['petstore_auth']['scopes']["write:pets"]).to eq "modify pets in your account"
        expect(parsed['petstore_auth']['scopes']["read:pets"]).to eq "read your pets"
      end
    end

end