require 'spec_helper'
require 'yaml'
require 'ruby-swagger/data/paths'

describe Swagger::Data::Paths do

  let(:payload) do
    {
      "/pets"=> {
        "get"=> {
          "description"=> "Returns all pets from the system that the user has access to",
          "produces"=> [ "application/json" ],
          "responses"=> {
            "200"=> {
              "description"=> "A list of pets.",
              "schema"=> {
                "type"=> "array",
                "items"=> {
                  "$ref"=> "#/definitions/pet"
                }
              }
            }
          }
        }
      }
    }
  end

  context 'when parsing' do
    it 'should create a valid Swagger::Data::Paths' do
      parsed = Swagger::Data::Paths.parse(payload)

      expect(parsed['/pets'].get.description).to eq 'Returns all pets from the system that the user has access to'
      expect(parsed['/pets'].get.produces).to eq [ "application/json" ]
      expect(parsed['/pets'].get.responses['200'].description).to eq "A list of pets."
      expect(parsed['/pets'].get.responses['200'].schema.type).to eq "array"
      expect(parsed['/pets'].get.responses['200'].schema.items['$ref']).to eq "#/definitions/pet"
    end
  end

  context 'when creating the object' do
    let(:object) do
      Swagger::Data::Paths.parse(payload)
    end

    it 'should convert it to a valid JSON' do
      parsed = OpenStruct.new JSON.parse(object.to_json)

      expect(parsed['/pets']['get']['description']).to eq 'Returns all pets from the system that the user has access to'
      expect(parsed['/pets']['get']['produces']).to eq [ "application/json" ]
      expect(parsed['/pets']['get']['responses']['200']['description']).to eq "A list of pets."
      expect(parsed['/pets']['get']['responses']['200']['schema']['type']).to eq "array"
      expect(parsed['/pets']['get']['responses']['200']['schema']['items']['$ref']).to eq "#/definitions/pet"
    end

    it 'should convert it to a valid YAML' do
      parsed = OpenStruct.new YAML.load(object.to_yaml)

      expect(parsed['/pets']['get']['description']).to eq 'Returns all pets from the system that the user has access to'
      expect(parsed['/pets']['get']['produces']).to eq [ "application/json" ]
      expect(parsed['/pets']['get']['responses']['200']['description']).to eq "A list of pets."
      expect(parsed['/pets']['get']['responses']['200']['schema']['type']).to eq "array"
      expect(parsed['/pets']['get']['responses']['200']['schema']['items']['$ref']).to eq "#/definitions/pet"
    end
  end

end