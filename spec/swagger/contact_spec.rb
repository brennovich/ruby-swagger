require 'spec_helper'
require 'yaml'

describe Swagger::Data::Contact do

  let(:payload) do
    {
        "name"=> "API Support",
        "url"=> "http://www.swagger.io/support",
        "email"=> "support@swagger.io"
    }
  end

  context 'when parsing' do
    it 'should create a valid Swagger::Data::Contact' do
      contact = Swagger::Data::Contact.parse(payload)

      expect(contact.name).to eq 'API Support'
      expect(contact.url).to eq 'http://www.swagger.io/support'
      expect(contact.email).to eq 'support@swagger.io'
    end

    context 'with an invalid url' do
      before { payload['url'] = 'bazinga!' }

      it 'should raise an error' do
        expect { Swagger::Data::Contact.parse(payload) }.to raise_error(ArgumentError)
      end
    end
  end

  context 'when creating the object' do
    let(:contact) do
      c = Swagger::Data::Contact.new
      c.name = "API Support"
      c.url = "http://www.swagger.io/support"
      c.email = "support@swagger.io"

      c
    end

    it 'should convert it to a valid JSON' do
      obj = OpenStruct.new JSON.parse(contact.to_json)

      expect(obj.name).to eq 'API Support'
      expect(obj.url).to eq 'http://www.swagger.io/support'
      expect(obj.email).to eq 'support@swagger.io'
    end

    it 'should convert it to a valid YAML' do
      obj = OpenStruct.new YAML.load(contact.to_yaml)

      expect(obj.name).to eq 'API Support'
      expect(obj.url).to eq 'http://www.swagger.io/support'
      expect(obj.email).to eq 'support@swagger.io'
    end
  end




end