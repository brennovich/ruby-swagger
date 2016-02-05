require 'spec_helper'
require 'yaml'
require 'ruby-swagger/data/external_documentation'

describe Swagger::Data::ExternalDocumentation do
  let(:payload) do
    {
      'description' => 'Find more info here',
      'url' => 'https://swagger.io'
    }
  end

  context 'when parsing' do
    it 'should create a valid Swagger::Data::ExternalDocumentation' do
      parsed = Swagger::Data::ExternalDocumentation.parse(payload)

      expect(parsed.description).to eq 'Find more info here'
      expect(parsed.url).to eq 'https://swagger.io'
    end
  end

  context 'when creating the object' do
    let(:object) do
      obj = Swagger::Data::ExternalDocumentation.new
      obj.description = 'Find more info here'
      obj.url = 'https://swagger.io'

      obj
    end

    it 'should convert it to a valid JSON' do
      obj = OpenStruct.new JSON.parse(object.to_json)

      expect(obj.description).to eq 'Find more info here'
      expect(obj.url).to eq 'https://swagger.io'
    end

    it 'should convert it to a valid YAML' do
      obj = OpenStruct.new YAML.load(object.to_yaml)

      expect(obj.description).to eq 'Find more info here'
      expect(obj.url).to eq 'https://swagger.io'
    end
  end
end
