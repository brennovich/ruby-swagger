require 'spec_helper'
require 'yaml'
require 'ruby-swagger/data/headers'

describe Swagger::Data::Headers do
  let(:payload) do
    {
      'X-Rate-Limit-Limit' => {
        'description' => 'The number of allowed requests in the current period',
        'type' => 'integer'
      },
      'X-Rate-Limit-Remaining' => {
        'description' => 'The number of remaining requests in the current period',
        'type' => 'integer'
      },
      'X-Rate-Limit-Reset' => {
        'description' => 'The number of seconds left in the current period',
        'type' => 'integer'
      }
    }
  end

  context 'when parsing' do
    it 'should create a valid Swagger::Data::Headers' do
      parsed = Swagger::Data::Headers.parse(payload)

      expect(parsed['X-Rate-Limit-Limit'].description).to eq 'The number of allowed requests in the current period'
      expect(parsed['X-Rate-Limit-Limit'].type).to eq 'integer'

      expect(parsed['X-Rate-Limit-Remaining'].description).to eq 'The number of remaining requests in the current period'
      expect(parsed['X-Rate-Limit-Remaining'].type).to eq 'integer'

      expect(parsed['X-Rate-Limit-Reset'].description).to eq 'The number of seconds left in the current period'
      expect(parsed['X-Rate-Limit-Reset'].type).to eq 'integer'
    end
  end

  context 'when creating the object' do
    let(:object) do
      Swagger::Data::Headers.parse(payload)
    end

    it 'should convert it to a valid JSON' do
      parsed = OpenStruct.new JSON.parse(object.to_json)

      expect(parsed['X-Rate-Limit-Limit']['description']).to eq 'The number of allowed requests in the current period'
      expect(parsed['X-Rate-Limit-Limit']['type']).to eq 'integer'

      expect(parsed['X-Rate-Limit-Remaining']['description']).to eq 'The number of remaining requests in the current period'
      expect(parsed['X-Rate-Limit-Remaining']['type']).to eq 'integer'

      expect(parsed['X-Rate-Limit-Reset']['description']).to eq 'The number of seconds left in the current period'
      expect(parsed['X-Rate-Limit-Reset']['type']).to eq 'integer'
    end

    it 'should convert it to a valid YAML' do
      parsed = OpenStruct.new YAML.load(object.to_yaml)

      expect(parsed['X-Rate-Limit-Limit']['description']).to eq 'The number of allowed requests in the current period'
      expect(parsed['X-Rate-Limit-Limit']['type']).to eq 'integer'

      expect(parsed['X-Rate-Limit-Remaining']['description']).to eq 'The number of remaining requests in the current period'
      expect(parsed['X-Rate-Limit-Remaining']['type']).to eq 'integer'

      expect(parsed['X-Rate-Limit-Reset']['description']).to eq 'The number of seconds left in the current period'
      expect(parsed['X-Rate-Limit-Reset']['type']).to eq 'integer'
    end
  end
end
