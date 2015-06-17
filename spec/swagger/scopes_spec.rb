require 'spec_helper'
require 'yaml'
require 'ruby-swagger/data/scopes'

describe Swagger::Data::Scopes do

  context 'OAuth2' do
    let(:payload) do
      {
          "write:pets"=> "modify pets in your account",
          "read:pets"=> "read your pets"
      }
    end

    context 'when parsing' do
      it 'should create a valid Swagger::Data::Scopes' do
        parsed = Swagger::Data::Scopes.parse(payload)

        expect(parsed["write:pets"]).to eq "modify pets in your account"
        expect(parsed["read:pets"]).to eq "read your pets"
      end
    end

    context 'when creating the object' do
      let(:object) do
        Swagger::Data::Scopes.parse(payload)
      end

      it 'should convert it to a valid JSON' do
        parsed = OpenStruct.new JSON.parse(object.to_json)

        expect(parsed["write:pets"]).to eq "modify pets in your account"
        expect(parsed["read:pets"]).to eq "read your pets"
      end

      it 'should convert it to a valid YAML' do
        parsed = OpenStruct.new YAML.load(object.to_yaml)

        expect(parsed["write:pets"]).to eq "modify pets in your account"
        expect(parsed["read:pets"]).to eq "read your pets"
      end
    end
  end

end