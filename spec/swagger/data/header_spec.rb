require 'spec_helper'
require 'yaml'
require 'ruby-swagger/data/header'

describe Swagger::Data::Header do
  let(:payload) do
    {
      'description' => 'The number of allowed requests in the current period',
      'type' => 'integer'
    }
  end

  context 'when parsing' do
    it 'should create a valid Swagger::Data::Header' do
      parsed = Swagger::Data::Header.parse(payload)

      expect(parsed.description).to eq 'The number of allowed requests in the current period'
      expect(parsed.type).to eq 'integer'
    end
  end

  context 'when creating the object' do
    let(:object) do
      Swagger::Data::Header.parse(payload)
    end

    it 'should convert it to a valid JSON' do
      parsed = OpenStruct.new JSON.parse(object.to_json)

      expect(parsed.description).to eq 'The number of allowed requests in the current period'
      expect(parsed.type).to eq 'integer'
    end

    it 'should convert it to a valid YAML' do
      parsed = OpenStruct.new YAML.load(object.to_yaml)

      expect(parsed.description).to eq 'The number of allowed requests in the current period'
      expect(parsed.type).to eq 'integer'
    end
  end
end
