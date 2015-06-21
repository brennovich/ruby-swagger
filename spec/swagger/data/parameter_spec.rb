require 'spec_helper'
require 'yaml'
require 'ruby-swagger/data/parameter'

describe Swagger::Data::Parameter do

  context 'A body parameter with a referenced schema definition' do
    let(:payload) do
      {
          "name" => "user",
          "in" => "body",
          "description" => "user to add to the system",
          "required" => true,
          "schema" => {
            "$ref" => "#/definitions/User"
          }
      }
    end

    context 'when parsing' do
      it 'should create a valid Swagger::Data::Parameter' do
        parsed = Swagger::Data::Parameter.parse(payload)

        expect(parsed.name).to eq 'user'
        expect(parsed.in).to eq 'body'
        expect(parsed.description).to eq 'user to add to the system'
        expect(parsed.required).to be_truthy
        expect(parsed.schema.ref).to eq '#/definitions/User'
      end
    end

    context 'when creating the object' do
      let(:object) do
        Swagger::Data::Parameter.parse(payload)
      end

      it 'should convert it to a valid JSON' do
        parsed = OpenStruct.new JSON.parse(object.to_json)

        expect(parsed.name).to eq 'user'
        expect(parsed.in).to eq 'body'
        expect(parsed.description).to eq 'user to add to the system'
        expect(parsed.required).to be_truthy
        expect(parsed.schema['$ref']).to eq '#/definitions/User'
      end

      it 'should convert it to a valid YAML' do
        parsed = OpenStruct.new YAML.load(object.to_yaml)

        expect(parsed.name).to eq 'user'
        expect(parsed.in).to eq 'body'
        expect(parsed.description).to eq 'user to add to the system'
        expect(parsed.required).to be_truthy
        expect(parsed.schema['$ref']).to eq '#/definitions/User'
      end
    end
  end

  context 'A body parameter that is an array of string values' do
    let(:payload) do
      {
          "name"=> "user",
          "in"=> "body",
          "description"=> "user to add to the system",
          "required"=> true,
          "schema"=> {
            "type"=> "array",
            "items"=> {
              "type"=> "string"
            }
          }
      }
    end

    context 'when parsing' do
      it 'should create a valid Swagger::Data::Parameter' do
        parsed = Swagger::Data::Parameter.parse(payload)

        expect(parsed.name).to eq 'user'
        expect(parsed.in).to eq 'body'
        expect(parsed.description).to eq 'user to add to the system'
        expect(parsed.required).to be_truthy
        expect(parsed.schema.type).to eq 'array'
        expect(parsed.schema.items['type']).to eq 'string'
      end
    end

    context 'when creating the object' do
      let(:object) do
        Swagger::Data::Parameter.parse(payload)
      end

      it 'should convert it to a valid JSON' do
        parsed = OpenStruct.new JSON.parse(object.to_json)

        expect(parsed.name).to eq 'user'
        expect(parsed.in).to eq 'body'
        expect(parsed.description).to eq 'user to add to the system'
        expect(parsed.required).to be_truthy
        expect(parsed.schema['type']).to eq 'array'
        expect(parsed.schema['items']['type']).to eq 'string'
      end

      it 'should convert it to a valid YAML' do
        parsed = OpenStruct.new YAML.load(object.to_yaml)

        expect(parsed.name).to eq 'user'
        expect(parsed.in).to eq 'body'
        expect(parsed.description).to eq 'user to add to the system'
        expect(parsed.required).to be_truthy
        expect(parsed.schema['type']).to eq 'array'
        expect(parsed.schema['items']['type']).to eq 'string'
      end
    end
  end

  context 'A header parameter with an array of 64 bit integer numbers' do
    let(:payload) do
      {
          "name"=> "token",
          "in"=> "header",
          "description"=> "token to be passed as a header",
          "required"=> true,
          "type"=> "array",
          "items"=> {
            "type"=> "integer",
            "format"=> "int64"
          },
          "collectionFormat"=> "csv"
      }
    end

    context 'when parsing' do
      it 'should create a valid Swagger::Data::Parameter' do
        parsed = Swagger::Data::Parameter.parse(payload)

        expect(parsed.name).to eq 'token'
        expect(parsed.in).to eq 'header'
        expect(parsed.description).to eq 'token to be passed as a header'
        expect(parsed.required).to be_truthy
        expect(parsed.type).to eq 'array'
        expect(parsed.items.type).to eq 'integer'
        expect(parsed.items.format).to eq 'int64'
        expect(parsed.collectionFormat).to eq 'csv'
      end
    end

    context 'when creating the object' do
      let(:object) do
        Swagger::Data::Parameter.parse(payload)
      end

      it 'should convert it to a valid JSON' do
        parsed = OpenStruct.new JSON.parse(object.to_json)

        expect(parsed.name).to eq 'token'
        expect(parsed.in).to eq 'header'
        expect(parsed.description).to eq 'token to be passed as a header'
        expect(parsed.required).to be_truthy
        expect(parsed.type).to eq 'array'
        expect(parsed.items['type']).to eq 'integer'
        expect(parsed.items['format']).to eq 'int64'
        expect(parsed.collectionFormat).to eq 'csv'
      end

      it 'should convert it to a valid YAML' do
        parsed = OpenStruct.new YAML.load(object.to_yaml)

        expect(parsed.name).to eq 'token'
        expect(parsed.in).to eq 'header'
        expect(parsed.description).to eq 'token to be passed as a header'
        expect(parsed.required).to be_truthy
        expect(parsed.type).to eq 'array'
        expect(parsed.items['type']).to eq 'integer'
        expect(parsed.items['format']).to eq 'int64'
        expect(parsed.collectionFormat).to eq 'csv'
      end
    end
  end

  context 'A path parameter of a string value' do
    let(:payload) do
      {
          "name"=> "username",
          "in"=> "path",
          "description"=> "username to fetch",
          "required"=> true,
          "type"=> "string"
      }
    end

    context 'when parsing' do
      it 'should create a valid Swagger::Data::Parameter' do
        parsed = Swagger::Data::Parameter.parse(payload)

        expect(parsed.name).to eq 'username'
        expect(parsed.in).to eq 'path'
        expect(parsed.description).to eq 'username to fetch'
        expect(parsed.required).to be_truthy
        expect(parsed.type).to eq 'string'
      end
    end

    context 'when creating the object' do
      let(:object) do
        Swagger::Data::Parameter.parse(payload)
      end

      it 'should convert it to a valid JSON' do
        parsed = OpenStruct.new JSON.parse(object.to_json)

        expect(parsed.name).to eq 'username'
        expect(parsed.in).to eq 'path'
        expect(parsed.description).to eq 'username to fetch'
        expect(parsed.required).to be_truthy
        expect(parsed.type).to eq 'string'
      end

      it 'should convert it to a valid YAML' do
        parsed = OpenStruct.new YAML.load(object.to_yaml)

        expect(parsed.name).to eq 'username'
        expect(parsed.in).to eq 'path'
        expect(parsed.description).to eq 'username to fetch'
        expect(parsed.required).to be_truthy
        expect(parsed.type).to eq 'string'
      end
    end
  end

  context 'An optional query parameter of a string value, allowing multiple values by repeating the query parameter' do
    let(:payload) do
      {
          "name"=> "id",
          "in"=> "query",
          "description"=> "ID of the object to fetch",
          "required"=> false,
          "type"=> "array",
          "items"=> {
            "type"=> "string"
          },
          "collectionFormat"=> "multi"
      }
    end

    context 'when parsing' do
      it 'should create a valid Swagger::Data::Parameter' do
        parsed = Swagger::Data::Parameter.parse(payload)

        expect(parsed.name).to eq 'id'
        expect(parsed.in).to eq 'query'
        expect(parsed.description).to eq 'ID of the object to fetch'
        expect(parsed.required).to be_falsey
        expect(parsed.type).to eq 'array'
        expect(parsed.items.type).to eq 'string'
        expect(parsed.collectionFormat).to eq 'multi'
      end
    end

    context 'when creating the object' do
      let(:object) do
        Swagger::Data::Parameter.parse(payload)
      end

      it 'should convert it to a valid JSON' do
        parsed = OpenStruct.new JSON.parse(object.to_json)

        expect(parsed.name).to eq 'id'
        expect(parsed.in).to eq 'query'
        expect(parsed.description).to eq 'ID of the object to fetch'
        expect(parsed.required).to be_falsey
        expect(parsed.type).to eq 'array'
        expect(parsed.items['type']).to eq 'string'
        expect(parsed.collectionFormat).to eq 'multi'
      end

      it 'should convert it to a valid YAML' do
        parsed = OpenStruct.new YAML.load(object.to_yaml)

        expect(parsed.name).to eq 'id'
        expect(parsed.in).to eq 'query'
        expect(parsed.description).to eq 'ID of the object to fetch'
        expect(parsed.required).to be_falsey
        expect(parsed.type).to eq 'array'
        expect(parsed.items['type']).to eq 'string'
        expect(parsed.collectionFormat).to eq 'multi'
      end
    end
  end

  context 'A form data with file type for a file upload' do
    let(:payload) do
      {
          "name"=> "avatar",
          "in"=> "formData",
          "description"=> "The avatar of the user",
          "required"=> true,
          "type"=> "file"
      }
    end

    context 'when parsing' do
      it 'should create a valid Swagger::Data::Parameter' do
        parsed = Swagger::Data::Parameter.parse(payload)

        expect(parsed.name).to eq 'avatar'
        expect(parsed.in).to eq 'formData'
        expect(parsed.description).to eq 'The avatar of the user'
        expect(parsed.required).to be_truthy
        expect(parsed.type).to eq 'file'
      end
    end

    context 'when creating the object' do
      let(:object) do
        Swagger::Data::Parameter.parse(payload)
      end

      it 'should convert it to a valid JSON' do
        parsed = OpenStruct.new JSON.parse(object.to_json)

        expect(parsed.name).to eq 'avatar'
        expect(parsed.in).to eq 'formData'
        expect(parsed.description).to eq 'The avatar of the user'
        expect(parsed.required).to be_truthy
        expect(parsed.type).to eq 'file'

      end

      it 'should convert it to a valid YAML' do
        parsed = OpenStruct.new YAML.load(object.to_yaml)

        expect(parsed.name).to eq 'avatar'
        expect(parsed.in).to eq 'formData'
        expect(parsed.description).to eq 'The avatar of the user'
        expect(parsed.required).to be_truthy
        expect(parsed.type).to eq 'file'
      end
    end
  end

end