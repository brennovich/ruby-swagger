require 'spec_helper'
require 'yaml'
require 'ruby-swagger/data/response'

describe Swagger::Data::Response do
  context 'Response of an array of a complex type' do
    let(:payload) do
      {
        'description' => 'A complex object array response',
        'schema' => {
          'type' => 'array',
          'items' => {
            '$ref' => '#/definitions/VeryComplexType'
          }
        }
      }
    end

    context 'when parsing' do
      it 'should create a valid Swagger::Data::Headers' do
        parsed = Swagger::Data::Response.parse(payload)

        expect(parsed.description).to eq 'A complex object array response'
        expect(parsed.schema.type).to eq 'array'
        expect(parsed.schema.items['$ref']).to eq '#/definitions/VeryComplexType'
      end
    end

    context 'when creating the object' do
      let(:object) do
        Swagger::Data::Response.parse(payload)
      end

      it 'should convert it to a valid JSON' do
        parsed = OpenStruct.new JSON.parse(object.to_json)

        expect(parsed.description).to eq 'A complex object array response'
        expect(parsed.schema['type']).to eq 'array'
        expect(parsed.schema['items']['$ref']).to eq '#/definitions/VeryComplexType'
      end

      it 'should convert it to a valid YAML' do
        parsed = OpenStruct.new YAML.load(object.to_yaml)

        expect(parsed.description).to eq 'A complex object array response'
        expect(parsed.schema['type']).to eq 'array'
        expect(parsed.schema['items']['$ref']).to eq '#/definitions/VeryComplexType'
      end
    end
  end

  context 'Response with a string type:' do
    let(:payload) do
      {
        'description' => 'A simple string response',
        'schema' => {
          'type' => 'string'
        }
      }
    end

    context 'when parsing' do
      it 'should create a valid Swagger::Data::Headers' do
        parsed = Swagger::Data::Response.parse(payload)

        expect(parsed.description).to eq 'A simple string response'
        expect(parsed.schema.type).to eq 'string'
      end
    end

    context 'when creating the object' do
      let(:object) do
        Swagger::Data::Response.parse(payload)
      end

      it 'should convert it to a valid JSON' do
        parsed = OpenStruct.new JSON.parse(object.to_json)

        expect(parsed.description).to eq 'A simple string response'
        expect(parsed.schema['type']).to eq 'string'
      end

      it 'should convert it to a valid YAML' do
        parsed = OpenStruct.new YAML.load(object.to_yaml)

        expect(parsed.description).to eq 'A simple string response'
        expect(parsed.schema['type']).to eq 'string'
      end
    end
  end

  context 'Response with headers' do
    let(:payload) do
      {
        'description' => 'A simple string response',
        'schema' => {
          'type' => 'string'
        },
        'headers' => {
          'X-Rate-Limit-Limit' => {
            'description' => 'The number of allowed requests in the current period',
            'type' => 'integer'
          },
          'X-Rate-Limit-Remaining' => {
            'description' => 'The number of remaining requests in the current period',
            'type' => 'integer'
          },
          'X-Rate-Limit-Reset' => {
            'description' => 'The number of seconds left in the current period',
            'type' => 'integer'
          }
        }
      }
    end

    context 'when parsing' do
      it 'should create a valid Swagger::Data::Headers' do
        parsed = Swagger::Data::Response.parse(payload)

        expect(parsed.description).to eq 'A simple string response'
        expect(parsed.schema.type).to eq 'string'

        expect(parsed.headers['X-Rate-Limit-Limit'].description).to eq 'The number of allowed requests in the current period'
        expect(parsed.headers['X-Rate-Limit-Limit'].type).to eq 'integer'

        expect(parsed.headers['X-Rate-Limit-Remaining'].description).to eq 'The number of remaining requests in the current period'
        expect(parsed.headers['X-Rate-Limit-Remaining'].type).to eq 'integer'

        expect(parsed.headers['X-Rate-Limit-Reset'].description).to eq 'The number of seconds left in the current period'
        expect(parsed.headers['X-Rate-Limit-Reset'].type).to eq 'integer'
      end
    end

    context 'when creating the object' do
      let(:object) do
        Swagger::Data::Response.parse(payload)
      end

      it 'should convert it to a valid JSON' do
        parsed = OpenStruct.new JSON.parse(object.to_json)

        expect(parsed.description).to eq 'A simple string response'
        expect(parsed.schema['type']).to eq 'string'

        expect(parsed.headers['X-Rate-Limit-Limit']['description']).to eq 'The number of allowed requests in the current period'
        expect(parsed.headers['X-Rate-Limit-Limit']['type']).to eq 'integer'

        expect(parsed.headers['X-Rate-Limit-Remaining']['description']).to eq 'The number of remaining requests in the current period'
        expect(parsed.headers['X-Rate-Limit-Remaining']['type']).to eq 'integer'

        expect(parsed.headers['X-Rate-Limit-Reset']['description']).to eq 'The number of seconds left in the current period'
        expect(parsed.headers['X-Rate-Limit-Reset']['type']).to eq 'integer'
      end

      it 'should convert it to a valid YAML' do
        parsed = OpenStruct.new YAML.load(object.to_yaml)

        expect(parsed.description).to eq 'A simple string response'
        expect(parsed.schema['type']).to eq 'string'

        expect(parsed.headers['X-Rate-Limit-Limit']['description']).to eq 'The number of allowed requests in the current period'
        expect(parsed.headers['X-Rate-Limit-Limit']['type']).to eq 'integer'

        expect(parsed.headers['X-Rate-Limit-Remaining']['description']).to eq 'The number of remaining requests in the current period'
        expect(parsed.headers['X-Rate-Limit-Remaining']['type']).to eq 'integer'

        expect(parsed.headers['X-Rate-Limit-Reset']['description']).to eq 'The number of seconds left in the current period'
        expect(parsed.headers['X-Rate-Limit-Reset']['type']).to eq 'integer'
      end
    end
  end

  context 'Response with no return value' do
    let(:payload) do
      {
        'description' => 'object created'
      }
    end

    context 'when parsing' do
      it 'should create a valid Swagger::Data::Headers' do
        parsed = Swagger::Data::Response.parse(payload)

        expect(parsed.description).to eq 'object created'
      end
    end

    context 'when creating the object' do
      let(:object) do
        Swagger::Data::Response.parse(payload)
      end

      it 'should convert it to a valid JSON' do
        parsed = OpenStruct.new JSON.parse(object.to_json)

        expect(parsed.description).to eq 'object created'
      end

      it 'should convert it to a valid YAML' do
        parsed = OpenStruct.new YAML.load(object.to_yaml)

        expect(parsed.description).to eq 'object created'
      end
    end
  end
end
