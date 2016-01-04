require 'spec_helper'
require 'yaml'
require 'ruby-swagger/data/operation'

describe Swagger::Data::Operation do
  let(:payload) do
    {
      'tags' => ['pet'],
      'summary' => 'Updates a pet in the store with form data',
      'description' => 'Zippo',
      'operationId' => 'updatePetWithForm',
      'consumes' => ['application/x-www-form-urlencoded'],
      'produces' => ['application/json', 'application/xml'],
      'parameters' => [
        {
          'name' => 'petId',
          'in' => 'path',
          'description' => 'ID of pet that needs to be updated',
          'required' => true,
          'type' => 'string'
        },
        {
          'name' => 'name',
          'in' => 'formData',
          'description' => 'Updated name of the pet',
          'required' => false,
          'type' => 'string'
        },
        {
          'name' => 'status',
          'in' => 'formData',
          'description' => 'Updated status of the pet',
          'required' => false,
          'type' => 'string'
        }
      ],
      'responses' => {
        '200' => {
          'description' => 'Pet updated.'
        },
        '405' => {
          'description' => 'Invalid input'
        }
      },
      'security' => [
        {
          'petstore_auth' => [
            'write:pets',
            'read:pets'
          ]
        }
      ]
    }
  end

  context 'when parsing' do
    it 'should create a valid Swagger::Data::Operation' do
      parsed = Swagger::Data::Operation.parse(payload)

      expect(parsed.tags).to eq ['pet']
      expect(parsed.summary).to eq 'Updates a pet in the store with form data'
      expect(parsed.description).to eq 'Zippo'
      expect(parsed.operationId).to eq 'updatePetWithForm'
      expect(parsed.consumes).to eq ['application/x-www-form-urlencoded']
      expect(parsed.produces).to eq ['application/json', 'application/xml']
      expect(parsed.parameters.count).to eq 3
      expect(parsed.responses['200'].description).to eq 'Pet updated.'
      expect(parsed.responses['405'].description).to eq 'Invalid input'
      expect(parsed.security.first['petstore_auth']).to eq ['write:pets', 'read:pets']
    end
  end

  context 'when creating the object' do
    let(:object) do
      Swagger::Data::Operation.parse(payload)
    end

    it 'should convert it to a valid JSON' do
      parsed = OpenStruct.new JSON.parse(object.to_json)

      expect(parsed.tags).to eq ['pet']
      expect(parsed.summary).to eq 'Updates a pet in the store with form data'
      expect(parsed.description).to eq 'Zippo'
      expect(parsed.operationId).to eq 'updatePetWithForm'
      expect(parsed.consumes).to eq ['application/x-www-form-urlencoded']
      expect(parsed.produces).to eq ['application/json', 'application/xml']
      expect(parsed.parameters.count).to eq 3
      expect(parsed.responses['200']['description']).to eq 'Pet updated.'
      expect(parsed.responses['405']['description']).to eq 'Invalid input'
      expect(parsed.security.first['petstore_auth']).to eq ['write:pets', 'read:pets']
    end

    it 'should convert it to a valid YAML' do
      expect { OpenStruct.new(YAML.load(object.to_yaml)) }.to_not raise_error
    end
  end
end
