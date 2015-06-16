require 'spec_helper'
require 'yaml'
require 'ruby-swagger/data/schema'

describe Swagger::Data::Schema do

  context 'Primitive Sample' do

    let(:payload) do
      {
          "type" => "string",
          "format" => "email"
      }
    end

    context 'when parsing' do
      it 'should create a valid Swagger::Data::Schema' do
        parsed = Swagger::Data::Schema.parse(payload)

        expect(parsed.type).to eq 'string'
        expect(parsed.format).to eq 'email'
      end
    end

    context 'when creating the object' do
      let(:object) do
        Swagger::Data::Schema.parse(payload)
      end

      it 'should convert it to a valid JSON' do
        parsed = OpenStruct.new JSON.parse(object.to_json)

        expect(parsed.type).to eq 'string'
        expect(parsed.format).to eq 'email'
      end

      it 'should convert it to a valid YAML' do
        parsed = OpenStruct.new YAML.load(object.to_yaml)

        expect(parsed.type).to eq 'string'
        expect(parsed.format).to eq 'email'
      end
    end


  end

  context 'Simple Model' do

    let(:payload) do
      {
          "type" => "object",
          "required"=> [ "name"],
          "properties"=> {
            "name"=> {
              "type"=> "string"
            },
            "address"=> {
              "$ref"=> "#/definitions/Address"
            },
            "age"=> {
              "type"=> "integer",
              "format"=> "int32",
              "minimum"=> 0
            }
          }
      }
    end

    context 'when parsing' do
      it 'should create a valid Swagger::Data::Schema' do
        parsed = Swagger::Data::Schema.parse(payload)

        expect(parsed.type).to eq 'object'
        expect(parsed.required).to eq ['name']
        expect(parsed.properties['name']['type']).to eq 'string'
        expect(parsed.properties['address']['$ref']).to eq '#/definitions/Address'
        expect(parsed.properties['age']['type']).to eq 'integer'
        expect(parsed.properties['age']['format']).to eq 'int32'
        expect(parsed.properties['age']['minimum']).to eq 0
      end
    end

    context 'when creating the object' do
      let(:object) do
        Swagger::Data::Schema.parse(payload)
      end

      it 'should convert it to a valid JSON' do
        parsed = OpenStruct.new JSON.parse(object.to_json)

        expect(parsed.type).to eq 'object'
        expect(parsed.required).to eq ['name']
        expect(parsed.properties['name']['type']).to eq 'string'
        expect(parsed.properties['address']['$ref']).to eq '#/definitions/Address'
        expect(parsed.properties['age']['type']).to eq 'integer'
        expect(parsed.properties['age']['format']).to eq 'int32'
        expect(parsed.properties['age']['minimum']).to eq 0
      end

      it 'should convert it to a valid YAML' do
        parsed = OpenStruct.new YAML.load(object.to_yaml)

        expect(parsed.type).to eq 'object'
        expect(parsed.required).to eq ['name']
        expect(parsed.properties['name']['type']).to eq 'string'
        expect(parsed.properties['address']['$ref']).to eq '#/definitions/Address'
        expect(parsed.properties['age']['type']).to eq 'integer'
        expect(parsed.properties['age']['format']).to eq 'int32'
        expect(parsed.properties['age']['minimum']).to eq 0
      end
    end


  end

  context 'Model with Map/Dictionary Properties' do
    let(:payload) do
      {
          "type" => "object",
          "additionalProperties" => {
            "type" => "string"
          }
      }
    end

    context 'when parsing' do
      it 'should create a valid Swagger::Data::Schema' do
        parsed = Swagger::Data::Schema.parse(payload)

        expect(parsed.type).to eq 'object'
        expect(parsed.additionalProperties['type']).to eq 'string'
      end
    end

    context 'when creating the object' do
      let(:object) do
        Swagger::Data::Schema.parse(payload)
      end

      it 'should convert it to a valid JSON' do
        parsed = OpenStruct.new JSON.parse(object.to_json)

        expect(parsed.type).to eq 'object'
        expect(parsed.additionalProperties['type']).to eq 'string'
      end

      it 'should convert it to a valid YAML' do
        parsed = OpenStruct.new YAML.load(object.to_yaml)

        expect(parsed.type).to eq 'object'
        expect(parsed.additionalProperties['type']).to eq 'string'
      end
    end

  end

  context 'For a string to model mapping' do
    let(:payload) do
      {
          "type" => "object",
          "additionalProperties" => {
            "$ref" => "#/definitions/ComplexModel"
          }
      }
    end

    context 'when parsing' do
      it 'should create a valid Swagger::Data::Schema' do
        parsed = Swagger::Data::Schema.parse(payload)

        expect(parsed.type).to eq 'object'
        expect(parsed.additionalProperties['$ref']).to eq '#/definitions/ComplexModel'
      end
    end

    context 'when creating the object' do
      let(:object) do
        Swagger::Data::Schema.parse(payload)
      end

      it 'should convert it to a valid JSON' do
        parsed = OpenStruct.new JSON.parse(object.to_json)

        expect(parsed.type).to eq 'object'
        expect(parsed.additionalProperties['$ref']).to eq '#/definitions/ComplexModel'
      end

      it 'should convert it to a valid YAML' do
        parsed = OpenStruct.new YAML.load(object.to_yaml)

        expect(parsed.type).to eq 'object'
        expect(parsed.additionalProperties['$ref']).to eq '#/definitions/ComplexModel'
      end
    end

  end

  context 'Model with Example' do
    let(:payload) do
      {
          "properties" => {
            "id" => {
              "type" => "integer",
              "format"=> "int64"
            },
            "name" => {
              "type" => "string"
            }
          },
          "required" => [
            "name"
          ],
          "example" => {
            "name" => "Puma",
            "id" => 1
          }
      }
    end

    context 'when parsing' do
      it 'should create a valid Swagger::Data::Schema' do
        parsed = Swagger::Data::Schema.parse(payload)

        expect(parsed.properties['id']['type']).to eq 'integer'
        expect(parsed.properties['id']['format']).to eq 'int64'
        expect(parsed.properties['name']['type']).to eq 'string'
        expect(parsed.required).to eq ['name']
        expect(parsed.example['name']).to eq 'Puma'
        expect(parsed.example['id']).to eq 1
      end
    end

    context 'when creating the object' do
      let(:object) do
        Swagger::Data::Schema.parse(payload)
      end

      it 'should convert it to a valid JSON' do
        parsed = OpenStruct.new JSON.parse(object.to_json)

        expect(parsed.properties['id']['type']).to eq 'integer'
        expect(parsed.properties['id']['format']).to eq 'int64'
        expect(parsed.properties['name']['type']).to eq 'string'
        expect(parsed.required).to eq ['name']
        expect(parsed.example['name']).to eq 'Puma'
        expect(parsed.example['id']).to eq 1
      end

      it 'should convert it to a valid YAML' do
        parsed = OpenStruct.new YAML.load(object.to_yaml)

        expect(parsed.properties['id']['type']).to eq 'integer'
        expect(parsed.properties['id']['format']).to eq 'int64'
        expect(parsed.properties['name']['type']).to eq 'string'
        expect(parsed.required).to eq ['name']
        expect(parsed.example['name']).to eq 'Puma'
        expect(parsed.example['id']).to eq 1
      end
    end
  end

  context 'Model with composition' do
    let(:payload) do
      {
          "definitions"=> {
            "ErrorModel"=> {
              "type"=> "object",
              "required"=> [
                "message",
                "code"
              ],
              "properties"=> {
                "message"=> {
                  "type"=> "string"
                },
                "code"=> {
                  "type"=> "integer",
                  "minimum"=> 100,
                  "maximum"=> 600
                }
              }
            },
          "ExtendedErrorModel"=> {
            "allOf"=> [
              {
                "$ref"=> "#/definitions/ErrorModel"
              },
              {
                "type"=> "object",
                "required"=> [
                  "rootCause"
                ],
                "properties"=> {
                  "rootCause"=> {
                    "type"=> "string"
                  }
                }
              }
            ]
          }
        }
      }
    end

    context 'when parsing' do
      it 'should create a valid Swagger::Data::Schema' do
        parsed = Swagger::Data::Schema.parse(payload['definitions']['ErrorModel'])

        expect(parsed.type).to eq 'object'
        expect(parsed.required).to eq ['message', 'code']
        expect(parsed.properties['message']['type']).to eq 'string'
        expect(parsed.properties['code']['type']).to eq 'integer'
        expect(parsed.properties['code']['minimum']).to eq 100
        expect(parsed.properties['code']['maximum']).to eq 600

        parsed = Swagger::Data::Schema.parse(payload['definitions']['ExtendedErrorModel'])

        expect(parsed.allOf.first['$ref']).to eq '#/definitions/ErrorModel'
        expect(parsed.allOf.last['type']).to eq 'object'
        expect(parsed.allOf.last['required']).to eq ['rootCause']
        expect(parsed.allOf.last['properties']['rootCause']['type']).to eq 'string'
      end
    end
  end

  context 'Models with Polymorphism Support' do
    let(:payload) do
      {
          "definitions"=> {
            "Pet"=> {
              "discriminator"=> "petType",
              "properties"=> {
                "name"=> {
                  "type"=> "string"
                },
                "petType"=> {
                  "type"=> "string"
                }
              },
              "required"=> [
                "name",
                "petType"
              ]
            }
          },
          "Cat"=> {
            "description"=> "A representation of a cat",
            "allOf"=> [
              {
                "$ref"=> "#/definitions/Pet"
              },
              {
                "properties"=> {
                  "huntingSkill"=> {
                    "type"=> "string",
                    "description"=> "The measured skill for hunting",
                    "default"=> "lazy",
                    "enum"=> [
                      "clueless",
                      "lazy",
                      "adventurous",
                      "aggressive"
                    ]
                  }
                },
                "required"=> [
                  "huntingSkill"
                ]
              }
            ]
          },
          "Dog"=> {
            "description"=> "A representation of a dog",
            "allOf"=> [
              {
                "$ref"=> "#/definitions/Pet"
              },
              {
                "properties"=> {
                    "packSize"=> {
                      "type"=> "integer",
                      "format"=> "int32",
                      "description"=> "the size of the pack the dog is from",
                      "default"=> 0,
                      "minimum"=> 0
                    }
                },
                "required"=> [
                  "packSize"
                ]
              }
            ]
          }
      }
    end

    context 'when parsing' do
      it 'should create a valid Swagger::Data::Schema' do
        parsed = Swagger::Data::Schema.parse(payload['definitions']['Pet'])

        expect(parsed.discriminator).to eq 'petType'
        expect(parsed.properties['name']['type']).to eq 'string'
        expect(parsed.properties['petType']['type']).to eq 'string'
        expect(parsed.required).to eq ["name", "petType"]

        parsed = Swagger::Data::Schema.parse(payload['Cat'])
        expect(parsed.description).to eq 'A representation of a cat'
        expect(parsed.allOf.first['$ref']).to eq '#/definitions/Pet'
        expect(parsed.allOf.last['properties']['huntingSkill']['type']).to eq 'string'
        expect(parsed.allOf.last['properties']['huntingSkill']['description']).to eq 'The measured skill for hunting'
        expect(parsed.allOf.last['properties']['huntingSkill']['default']).to eq 'lazy'
        expect(parsed.allOf.last['properties']['huntingSkill']['enum']).to eq [ "clueless", "lazy", "adventurous", "aggressive"]
        expect(parsed.allOf.last['required']).to eq ['huntingSkill']

        parsed = Swagger::Data::Schema.parse(payload['Dog'])
        expect(parsed.description).to eq 'A representation of a dog'
        expect(parsed.allOf.first['$ref']).to eq '#/definitions/Pet'
        expect(parsed.allOf.last['properties']['packSize']['type']).to eq 'integer'
        expect(parsed.allOf.last['properties']['packSize']['format']).to eq 'int32'
        expect(parsed.allOf.last['properties']['packSize']['description']).to eq 'the size of the pack the dog is from'
        expect(parsed.allOf.last['properties']['packSize']['default']).to eq 0
        expect(parsed.allOf.last['properties']['packSize']['minimum']).to eq 0
      end
    end
  end




end