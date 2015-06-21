require 'spec_helper'
require 'yaml'
require 'ruby-swagger/data/example'

describe Swagger::Data::Example do

  let(:payload) do
    {
        "application/json"=> {
          "name"=> "Puma",
          "type"=> "Dog",
          "color"=> "Black",
          "gender"=> "Female",
          "breed"=> "Mixed"
        }
    }
  end

  context 'when parsing' do
    it 'should create a valid Swagger::Data::Example' do
      parsed = Swagger::Data::Example.parse(payload)

      expect(parsed.examples['application/json']).to eq payload['application/json']
    end
  end

  context 'when creating the object' do
    let(:object) do
      obj = Swagger::Data::Example.new
      obj.examples = payload

      obj
    end

    it 'should convert it to a valid JSON' do
      obj = OpenStruct.new JSON.parse(object.to_json)

      expect(obj['application/json']).to eq payload['application/json']
    end

    it 'should convert it to a valid YAML' do
      obj = OpenStruct.new YAML.load(object.to_yaml)

      expect(obj['application/json']).to eq payload['application/json']
    end
  end




end