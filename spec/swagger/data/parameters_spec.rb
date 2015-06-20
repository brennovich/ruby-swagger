require 'spec_helper'
require 'yaml'
require 'ruby-swagger/data/parameters'

describe Swagger::Data::Parameters do

  let(:payload) do
    {
        "skipParam"=> {
          "name"=> "skip",
          "in"=> "query",
          "description"=> "number of items to skip",
          "required"=> true,
          "type"=> "integer",
          "format"=> "int32"
        },
        "limitParam"=> {
          "name"=> "limit",
          "in"=> "query",
          "description"=> "max records to return",
          "required"=> true,
          "type"=> "integer",
          "format"=> "int32"
        }
    }
  end

  context 'when parsing' do
    it 'should create a valid Swagger::Data::Parameters' do
      parsed = Swagger::Data::Parameters.parse(payload)

      expect(parsed.params).to eq ['skipParam', 'limitParam']

      expect(parsed['skipParam'].name).to eq 'skip'
      expect(parsed['skipParam'].in).to eq 'query'
      expect(parsed['skipParam'].description).to eq 'number of items to skip'
      expect(parsed['skipParam'].required).to be_truthy
      expect(parsed['skipParam'].type).to eq 'integer'
      expect(parsed['skipParam'].format).to eq 'int32'

      expect(parsed['limitParam'].name).to eq 'limit'
      expect(parsed['limitParam'].in).to eq 'query'
      expect(parsed['limitParam'].description).to eq 'max records to return'
      expect(parsed['limitParam'].required).to be_truthy
      expect(parsed['limitParam'].type).to eq 'integer'
      expect(parsed['limitParam'].format).to eq 'int32'
    end
  end

  context 'when creating the object' do
    let(:object) do
      Swagger::Data::Parameters.parse(payload)
    end

    it 'should convert it to a valid JSON' do
      parsed = OpenStruct.new JSON.parse(object.to_json)

      expect(parsed['skipParam']['name']).to eq 'skip'
      expect(parsed['skipParam']['in']).to eq 'query'
      expect(parsed['skipParam']['description']).to eq 'number of items to skip'
      expect(parsed['skipParam']['required']).to be_truthy
      expect(parsed['skipParam']['type']).to eq 'integer'
      expect(parsed['skipParam']['format']).to eq 'int32'

      expect(parsed['limitParam']['name']).to eq 'limit'
      expect(parsed['limitParam']['in']).to eq 'query'
      expect(parsed['limitParam']['description']).to eq 'max records to return'
      expect(parsed['limitParam']['required']).to be_truthy
      expect(parsed['limitParam']['type']).to eq 'integer'
      expect(parsed['limitParam']['format']).to eq 'int32'
    end

    it 'should convert it to a valid YAML' do
      parsed = OpenStruct.new YAML.load(object.to_yaml)

      expect(parsed['skipParam']['name']).to eq 'skip'
      expect(parsed['skipParam']['in']).to eq 'query'
      expect(parsed['skipParam']['description']).to eq 'number of items to skip'
      expect(parsed['skipParam']['required']).to be_truthy
      expect(parsed['skipParam']['type']).to eq 'integer'
      expect(parsed['skipParam']['format']).to eq 'int32'

      expect(parsed['limitParam']['name']).to eq 'limit'
      expect(parsed['limitParam']['in']).to eq 'query'
      expect(parsed['limitParam']['description']).to eq 'max records to return'
      expect(parsed['limitParam']['required']).to be_truthy
      expect(parsed['limitParam']['type']).to eq 'integer'
      expect(parsed['limitParam']['format']).to eq 'int32'
    end
  end

end