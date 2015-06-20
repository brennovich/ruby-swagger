require 'spec_helper'
require 'yaml'
require 'ruby-swagger/data/security_requirement'

describe Swagger::Data::SecurityRequirement do

  context 'Non-OAuth2' do
    let(:payload) do
      {
          "api_key" => []
      }
    end

    context 'when parsing' do
      it 'should create a valid Swagger::Data::SecurityRequirement' do
        parsed = Swagger::Data::SecurityRequirement.parse(payload)

        expect(parsed['api_key']).to eq []
      end
    end

    context 'when creating the object' do
      let(:object) do
        Swagger::Data::SecurityRequirement.parse(payload)
      end

      it 'should convert it to a valid JSON' do
        parsed = OpenStruct.new JSON.parse(object.to_json)

        expect(parsed['api_key']).to eq []
      end

      it 'should convert it to a valid YAML' do
        parsed = OpenStruct.new YAML.load(object.to_yaml)

        expect(parsed['api_key']).to eq []
      end
    end
  end

  context 'OAuth2' do
    let(:payload) do
      {
          "petstore_auth"=> [
              "write:pets",
              "read:pets"
          ]
      }
    end

    context 'when parsing' do
      it 'should create a valid Swagger::Data::SecurityRequirement' do
        parsed = Swagger::Data::SecurityRequirement.parse(payload)

        expect(parsed['petstore_auth']).to eq ["write:pets", "read:pets"]
      end
    end

    context 'when creating the object' do
      let(:object) do
        Swagger::Data::SecurityRequirement.parse(payload)
      end

      it 'should convert it to a valid JSON' do
        parsed = OpenStruct.new JSON.parse(object.to_json)

        expect(parsed['petstore_auth']).to eq ["write:pets", "read:pets"]
      end

      it 'should convert it to a valid YAML' do
        parsed = OpenStruct.new YAML.load(object.to_yaml)

        expect(parsed['petstore_auth']).to eq ["write:pets", "read:pets"]
      end
    end
  end

end