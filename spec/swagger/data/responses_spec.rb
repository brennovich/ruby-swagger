require 'spec_helper'
require 'yaml'
require 'ruby-swagger/data/responses'

describe Swagger::Data::Responses do

  context 'Response of an array of a complex type' do
    let(:payload) do
      {
          "200"=> {
            "description"=> "a pet to be returned",
            "schema"=> {
              "$ref"=> "#/definitions/Pet"
            }
          },
          "default"=> {
            "description"=> "Unexpected error",
            "schema"=> {
              "$ref"=> "#/definitions/ErrorModel"
            }
          }
      }
    end

    context 'when parsing' do
      it 'should create a valid Swagger::Data::Responses' do
        parsed = Swagger::Data::Responses.parse(payload)

        expect(parsed['200'].description).to eq 'a pet to be returned'
        expect(parsed['200'].schema.ref).to eq '#/definitions/Pet'

        expect(parsed['default'].description).to eq 'Unexpected error'
        expect(parsed['default'].schema.ref).to eq '#/definitions/ErrorModel'
      end
    end

    context 'when creating the object' do
      let(:object) do
        Swagger::Data::Responses.parse(payload)
      end

      it 'should convert it to a valid JSON' do
        parsed = OpenStruct.new JSON.parse(object.to_json)

        expect(parsed['200']['description']).to eq 'a pet to be returned'
        expect(parsed['200']['schema']['$ref']).to eq '#/definitions/Pet'

        expect(parsed['default']['description']).to eq 'Unexpected error'
        expect(parsed['default']['schema']['$ref']).to eq '#/definitions/ErrorModel'
      end

      it 'should convert it to a valid YAML' do
        parsed = OpenStruct.new YAML.load(object.to_yaml)

        expect(parsed['200']['description']).to eq 'a pet to be returned'
        expect(parsed['200']['schema']['$ref']).to eq '#/definitions/Pet'

        expect(parsed['default']['description']).to eq 'Unexpected error'
        expect(parsed['default']['schema']['$ref']).to eq '#/definitions/ErrorModel'
      end
    end
  end

end