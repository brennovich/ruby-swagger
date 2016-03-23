require 'spec_helper'

require_relative '../../fixtures/grape/entities/status_entity'

RSpec.describe Swagger::Grape::Entity do
  describe '#to_swagger' do
    it 'converts exposures definition into swagger definition' do
      object_translator = described_class.new(ImageEntity.to_s)

      expect(object_translator.to_swagger).to eq(
        {
          'type' => 'object',
          'properties' => {
            'url' => {
              'type' => 'string',
              'description' => 'The url of the image'
            },
            'name' => {
              'type' => 'string',
              'description' => 'The name of the image'
            },
            'size' => {
              'type' => 'integer',
              'description' => 'Size of the picture'
            }
          }
        }
      )
    end
  end

  describe '#sub_types' do
    it 'returns nested objects of a given entity' do
      object_translator = described_class.new(StatusEntity.to_s)

      expect(object_translator.sub_types).to eq([ImageEntity, StatusEntity])
    end
  end
end
