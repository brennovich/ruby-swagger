require 'spec_helper'

require_relative '../../fixtures/grape/representers/status_representer'

RSpec.describe Swagger::Grape::Representer do
  describe '#to_swagger' do
    it 'converts exposures definition into swagger definition' do
      object_translator = described_class.new(StatusRepresenter.to_s)

      expect(object_translator.to_swagger).to eq({
        'type' => 'object',
        'properties' => {
          'user_name' => {
            'type' => 'string'
          },
          'text' => {
            'type' => 'string',
            'description' => 'Status update text.'
          },
          'ip' => {
            'type' => 'string'
          },
          'user_type' => {
            'type' => 'string'
          },
          'user_id' => {
            'type' => 'string'
          },
          'contact_info' => {
            'type' => 'object',
            'properties' => {
              'phone' => {
                'type' => 'string'
              },
              'address' => {
                'type' => 'object',
                '$ref' => '#/definitions/ImageRepresenter'
              }
            }
          },
          'digest' => {
            'type' => 'string'
          },
          'responses' => {
            'type' => 'object',
            '$ref' => '#/definitions/StatusRepresenter'
          },
          'last_reply' => {
            'type' => 'object',
            '$ref' => '#/definitions/StatusRepresenter'
          },
          'list' => {
            'type' => 'array',
            'description' => 'List of elements',
            'items' => {
              'type' => 'object',
              'properties' => {
                'option_a' => {
                  'type' => 'object',
                  'properties' => {
                    'option_b' => {
                      'type' => 'array',
                      'items' => {
                        'type' => 'string'
                      },
                      'description' => 'An option'
                    }
                  }
                },
                'option_c' => {
                  'type' => 'integer',
                  'description' => 'Last option'
                }
              }
            }
          },
          'created_at' => {
            'type' => 'string'
          },
          'updated_at' => {
            'type' => 'string'
          }
        }
      })
    end
  end

  describe '#sub_types' do
    it 'returns nested objects of a given entity' do
      object_translator = described_class.new(StatusRepresenter.to_s)

      expect(object_translator.sub_types).to eq([ImageRepresenter, StatusRepresenter])
    end
  end
end
