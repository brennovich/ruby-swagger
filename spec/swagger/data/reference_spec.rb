require 'spec_helper'
require 'yaml'
require 'ruby-swagger/data/reference'

describe Swagger::Data::Reference do

  let(:payload) do
    {
        "$ref" => "#/definitions/Pet"
    }
  end

  context 'when parsing' do
    it 'should create a valid Swagger::Data::Reference' do
      parsed = Swagger::Data::Reference.parse(payload)

      expect(parsed.ref).to eq "#/definitions/Pet"
    end
  end

  context 'when creating the object' do
    let(:object) do
      Swagger::Data::Reference.parse(payload)
    end

    it 'should convert it to a valid JSON' do
      parsed = OpenStruct.new JSON.parse(object.to_json)

      expect(parsed['$ref']).to eq "#/definitions/Pet"
    end

    it 'should convert it to a valid YAML' do
      parsed = OpenStruct.new YAML.load(object.to_yaml)

      expect(parsed['$ref']).to eq "#/definitions/Pet"
    end
  end

end