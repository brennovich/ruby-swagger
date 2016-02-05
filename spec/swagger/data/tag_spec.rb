require 'spec_helper'
require 'yaml'
require 'ruby-swagger/data/tag'

describe Swagger::Data::Tag do
  let(:payload) do
    {
      'name' => 'pet',
      'description' => 'Pets operations',
      'externalDocs' => {
        'description' => 'Find more info here',
        'url' => 'https://swagger.io'
      }
    }
  end

  context 'when parsing' do
    it 'should create a valid Swagger::Data::Tag' do
      parsed = Swagger::Data::Tag.parse(payload)

      expect(parsed.name).to eq 'pet'
      expect(parsed.description).to eq 'Pets operations'
      expect(parsed.externalDocs.description).to eq 'Find more info here'
      expect(parsed.externalDocs.url).to eq 'https://swagger.io'
    end
  end

  context 'when creating the object' do
    let(:object) do
      Swagger::Data::Tag.parse(payload)
    end

    it 'should convert it to a valid JSON' do
      parsed = OpenStruct.new JSON.parse(object.to_json)

      expect(parsed.name).to eq 'pet'
      expect(parsed.description).to eq 'Pets operations'
      expect(parsed.externalDocs['description']).to eq 'Find more info here'
      expect(parsed.externalDocs['url']).to eq 'https://swagger.io'
    end

    it 'should convert it to a valid YAML' do
      parsed = OpenStruct.new YAML.load(object.to_yaml)

      expect(parsed.name).to eq 'pet'
      expect(parsed.description).to eq 'Pets operations'
      expect(parsed.externalDocs['description']).to eq 'Find more info here'
      expect(parsed.externalDocs['url']).to eq 'https://swagger.io'
    end
  end
end
