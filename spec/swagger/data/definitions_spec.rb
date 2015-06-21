require 'spec_helper'
require 'yaml'
require 'ruby-swagger/data/definitions'

describe Swagger::Data::Definitions do

  let(:payload) do
    {
        "Category"=> {
          "properties"=> {
            "id"=> {
              "type"=> "integer",
              "format"=> "int64"
            },
            "name"=> {
              "type"=> "string"
            }
          }
        },
        "Tag"=> {
          "properties"=> {
            "id"=> {
              "type"=> "integer",
              "format"=> "int64"
            },
            "name"=> {
              "type"=> "string"
            }
          }
        }
    }
  end

  context 'when parsing' do
    it 'should create a valid Swagger::Data::Definitions' do
      parsed = Swagger::Data::Definitions.parse(payload)

      expect(parsed['Category'].properties['id']['type']).to eq 'integer'
      expect(parsed['Category'].properties['id']['format']).to eq 'int64'
      expect(parsed['Category'].properties['name']['type']).to eq 'string'

      expect(parsed['Tag'].properties['id']['type']).to eq 'integer'
      expect(parsed['Tag'].properties['id']['format']).to eq 'int64'
      expect(parsed['Tag'].properties['name']['type']).to eq 'string'
    end
  end

  context 'when creating the object' do
    let(:object) do
      Swagger::Data::Definitions.parse(payload)
    end

    it 'should convert it to a valid JSON' do
      parsed = OpenStruct.new JSON.parse(object.to_json)

      expect(parsed['Category']['properties']['id']['type']).to eq 'integer'
      expect(parsed['Category']['properties']['id']['format']).to eq 'int64'
      expect(parsed['Category']['properties']['name']['type']).to eq 'string'

      expect(parsed['Tag']['properties']['id']['type']).to eq 'integer'
      expect(parsed['Tag']['properties']['id']['format']).to eq 'int64'
      expect(parsed['Tag']['properties']['name']['type']).to eq 'string'
    end

    it 'should convert it to a valid YAML' do
      parsed = OpenStruct.new YAML.load(object.to_yaml)

      expect(parsed['Category']['properties']['id']['type']).to eq 'integer'
      expect(parsed['Category']['properties']['id']['format']).to eq 'int64'
      expect(parsed['Category']['properties']['name']['type']).to eq 'string'

      expect(parsed['Tag']['properties']['id']['type']).to eq 'integer'
      expect(parsed['Tag']['properties']['id']['format']).to eq 'int64'
      expect(parsed['Tag']['properties']['name']['type']).to eq 'string'
    end
  end

end