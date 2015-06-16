require 'spec_helper'
require 'yaml'
require 'ruby-swagger/data/items'

describe Swagger::Data::Items do

  let(:payload) do
    {
        "type"=> "array",
        "items"=> {
          "type"=> "integer",
          "minimum"=> 0,
          "maximum"=> 63
        }
    }
  end

  context 'when parsing' do
    it 'should create a valid Swagger::Data::Items' do
      parsed = Swagger::Data::Items.parse(payload)

      expect(parsed.type).to eq 'array'
      expect(parsed.items.type).to eq 'integer'
      expect(parsed.items.minimum).to eq 0
      expect(parsed.items.maximum).to eq 63
    end
  end

  context 'when creating the object' do
    let(:object) do
      Swagger::Data::Items.parse(payload)
    end

    it 'should convert it to a valid JSON' do
      parsed = OpenStruct.new JSON.parse(object.to_json)

      expect(parsed.type).to eq 'array'
      expect(parsed.items['type']).to eq 'integer'
      expect(parsed.items['minimum']).to eq 0
      expect(parsed.items['maximum']).to eq 63
    end

    it 'should convert it to a valid YAML' do
      parsed = OpenStruct.new YAML.load(object.to_yaml)

      expect(parsed.type).to eq 'array'
      expect(parsed.items['type']).to eq 'integer'
      expect(parsed.items['minimum']).to eq 0
      expect(parsed.items['maximum']).to eq 63
    end
  end

end