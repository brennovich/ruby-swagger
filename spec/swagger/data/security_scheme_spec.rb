require 'spec_helper'
require 'yaml'
require 'ruby-swagger/data/security_scheme'

describe Swagger::Data::SecurityScheme do

  context 'Basic Authentication Sample' do
    let(:payload) do
      {
          "type" => "basic"
      }
    end

    context 'when parsing' do
      it 'should create a valid Swagger::Data::SecurityScheme' do
        parsed = Swagger::Data::SecurityScheme.parse(payload)

        expect(parsed.type).to eq 'basic'
      end
    end


    context 'when creating the object' do
      let(:object) do
        Swagger::Data::SecurityScheme.parse(payload)
      end

      it 'should convert it to a valid JSON' do
        parsed = OpenStruct.new JSON.parse(object.to_json)

        expect(parsed.type).to eq 'basic'
      end

      it 'should convert it to a valid YAML' do
        parsed = OpenStruct.new YAML.load(object.to_yaml)

        expect(parsed.type).to eq 'basic'
      end
    end

  end

  context 'API Key Sample' do
    let(:payload) do
      {
          "type" => "apiKey",
          "name" => "api_key",
          "in" => "header"
      }
    end

    context 'when parsing' do
      it 'should create a valid Swagger::Data::SecurityScheme' do
        parsed = Swagger::Data::SecurityScheme.parse(payload)

        expect(parsed.type).to eq 'apiKey'
        expect(parsed.name).to eq 'api_key'
        expect(parsed.in).to eq 'header'
      end
    end

    context 'when creating the object' do
      let(:object) do
        Swagger::Data::SecurityScheme.parse(payload)
      end

      it 'should convert it to a valid JSON' do
        parsed = OpenStruct.new JSON.parse(object.to_json)

        expect(parsed.type).to eq 'apiKey'
        expect(parsed.name).to eq 'api_key'
        expect(parsed.in).to eq 'header'
      end

      it 'should convert it to a valid YAML' do
        parsed = OpenStruct.new YAML.load(object.to_yaml)

        expect(parsed.type).to eq 'apiKey'
        expect(parsed.name).to eq 'api_key'
        expect(parsed.in).to eq 'header'
      end
    end

  end

  context 'Implicit OAuth2 Sample' do
    let(:payload) do
      {
          "type" => "oauth2",
          "authorizationUrl" => "http://swagger.io/api/oauth/dialog",
          "flow" => "implicit",
          "scopes" => {
            "write:pets" => "modify pets in your account",
            "read:pets" => "read your pets"
          }
      }
    end

    context 'when parsing' do
      it 'should create a valid Swagger::Data::SecurityScheme' do
        parsed = Swagger::Data::SecurityScheme.parse(payload)

        expect(parsed.type).to eq 'oauth2'
        expect(parsed.authorizationUrl).to eq 'http://swagger.io/api/oauth/dialog'
        expect(parsed.flow).to eq 'implicit'
        expect(parsed.scopes['write:pets']).to eq 'modify pets in your account'
        expect(parsed.scopes['read:pets']).to eq 'read your pets'
      end
    end

    context 'when creating the object' do
      let(:object) do
        Swagger::Data::SecurityScheme.parse(payload)
      end

      it 'should convert it to a valid JSON' do
        parsed = OpenStruct.new JSON.parse(object.to_json)

        expect(parsed.type).to eq 'oauth2'
        expect(parsed.authorizationUrl).to eq 'http://swagger.io/api/oauth/dialog'
        expect(parsed.flow).to eq 'implicit'
        expect(parsed.scopes['write:pets']).to eq 'modify pets in your account'
        expect(parsed.scopes['read:pets']).to eq 'read your pets'
      end

      it 'should convert it to a valid YAML' do
        parsed = OpenStruct.new YAML.load(object.to_yaml)

        expect(parsed.type).to eq 'oauth2'
        expect(parsed.authorizationUrl).to eq 'http://swagger.io/api/oauth/dialog'
        expect(parsed.flow).to eq 'implicit'
        expect(parsed.scopes['write:pets']).to eq 'modify pets in your account'
        expect(parsed.scopes['read:pets']).to eq 'read your pets'
      end
    end

  end

end