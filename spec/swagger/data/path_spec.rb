require 'spec_helper'
require 'yaml'
require 'ruby-swagger/data/path'

describe Swagger::Data::Path do

  let(:payload) do
    {
        "get"=> {
          "description"=> "Returns pets based on ID",
          "summary"=> "Find pets by ID",
          "operationId"=> "getPetsById",
          "produces"=> [
            "application/json",
            "text/html"
          ],
          "responses"=> {
            "200"=> {
              "description"=> "pet response",
              "schema"=> {
                "type"=> "array",
                "items"=> {
                  "$ref"=> "#/definitions/Pet"
                }
              }
            },
            "default"=> {
              "description"=> "error payload",
              "schema"=> {
                "$ref"=> "#/definitions/ErrorModel"
              }
            }
          }
        },
        "parameters"=> [
          {
            "name"=> "id",
            "in"=> "path",
            "description"=> "ID of pet to use",
            "required"=> true,
            "type"=> "array",
            "items"=> {
              "type"=> "string"
            },
            "collectionFormat"=> "csv"
          }
        ]
    }
  end

  context 'when parsing' do
    it 'should create a valid Swagger::Data::Path' do
      parsed = Swagger::Data::Path.parse(payload)

      expect(parsed.get.description).to eq 'Returns pets based on ID'
      expect(parsed.get.summary).to eq 'Find pets by ID'
      expect(parsed.get.operationId).to eq 'getPetsById'
      expect(parsed.get.produces).to eq ["application/json", "text/html"]

      expect(parsed.get.responses['200'].description).to eq 'pet response'
      expect(parsed.get.responses['200'].schema.type).to eq 'array'
      expect(parsed.get.responses['200'].schema.items['$ref']).to eq '#/definitions/Pet'
      expect(parsed.get.responses['default'].description).to eq 'error payload'
      expect(parsed.get.responses['default'].schema.ref).to eq '#/definitions/ErrorModel'

      expect(parsed.parameters.first.name).to eq 'id'
      expect(parsed.parameters.first.in).to eq 'path'
      expect(parsed.parameters.first.description).to eq 'ID of pet to use'
      expect(parsed.parameters.first.required).to be_truthy
      expect(parsed.parameters.first.type).to eq 'array'
      expect(parsed.parameters.first.items.type).to eq 'string'
      expect(parsed.parameters.first.collectionFormat).to eq 'csv'
    end
  end

  context 'when creating the object' do
    let(:object) do
      Swagger::Data::Path.parse(payload)
    end

    it 'should convert it to a valid JSON' do
      parsed = OpenStruct.new JSON.parse(object.to_json)

      expect(parsed.get['description']).to eq 'Returns pets based on ID'
      expect(parsed.get['summary']).to eq 'Find pets by ID'
      expect(parsed.get['operationId']).to eq 'getPetsById'
      expect(parsed.get['produces']).to eq ["application/json", "text/html"]

      expect(parsed.get['responses']['200']['description']).to eq 'pet response'
      expect(parsed.get['responses']['200']['schema']['type']).to eq 'array'
      expect(parsed.get['responses']['200']['schema']['items']['$ref']).to eq '#/definitions/Pet'
      expect(parsed.get['responses']['default']['description']).to eq 'error payload'
      expect(parsed.get['responses']['default']['schema']['$ref']).to eq '#/definitions/ErrorModel'

      expect(parsed.parameters.first['name']).to eq 'id'
      expect(parsed.parameters.first['in']).to eq 'path'
      expect(parsed.parameters.first['description']).to eq 'ID of pet to use'
      expect(parsed.parameters.first['required']).to be_truthy
      expect(parsed.parameters.first['type']).to eq 'array'
      expect(parsed.parameters.first['items']['type']).to eq 'string'
      expect(parsed.parameters.first['collectionFormat']).to eq 'csv'
    end

    it 'should convert it to a valid YAML' do
      parsed = OpenStruct.new YAML.load(object.to_yaml)

      expect(parsed.get['description']).to eq 'Returns pets based on ID'
      expect(parsed.get['summary']).to eq 'Find pets by ID'
      expect(parsed.get['operationId']).to eq 'getPetsById'
      expect(parsed.get['produces']).to eq ["application/json", "text/html"]

      expect(parsed.get['responses']['200']['description']).to eq 'pet response'
      expect(parsed.get['responses']['200']['schema']['type']).to eq 'array'
      expect(parsed.get['responses']['200']['schema']['items']['$ref']).to eq '#/definitions/Pet'
      expect(parsed.get['responses']['default']['description']).to eq 'error payload'
      expect(parsed.get['responses']['default']['schema']['$ref']).to eq '#/definitions/ErrorModel'

      expect(parsed.parameters.first['name']).to eq 'id'
      expect(parsed.parameters.first['in']).to eq 'path'
      expect(parsed.parameters.first['description']).to eq 'ID of pet to use'
      expect(parsed.parameters.first['required']).to be_truthy
      expect(parsed.parameters.first['type']).to eq 'array'
      expect(parsed.parameters.first['items']['type']).to eq 'string'
      expect(parsed.parameters.first['collectionFormat']).to eq 'csv'
    end
  end

end