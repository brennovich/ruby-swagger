require 'spec_helper'
require 'yaml'

describe Swagger::Info do

  let(:payload) do
    {
        "title"=> "Swagger Sample App",
        "description"=> "This is a sample server Petstore server.",
        "termsOfService"=> "http=>:swagger.io/terms/",
        "contact"=> {
            "name"=> "API Support",
            "url"=> "http://www.swagger.io/support",
            "email"=> "support@swagger.io"
        },
        "license"=> {
            "name"=> "Apache 2.0",
            "url"=> "http://www.apache.org/licenses/LICENSE-2.0.html"
        },
        "version"=> "1.0.1"
    }
  end

  context 'when parsing' do
    it 'should create a valid Swagger::Info' do
      info = Swagger::Info.parse(payload)

      expect(info.title).to eq "Swagger Sample App"
      expect(info.description).to eq "This is a sample server Petstore server."
      expect(info.termsOfService).to eq "http=>:swagger.io/terms/"
      expect(info.contact.name).to eq 'API Support'
      expect(info.contact.url).to eq 'http://www.swagger.io/support'
      expect(info.contact.email).to eq 'support@swagger.io'
      expect(info.license.name).to eq 'Apache 2.0'
      expect(info.license.url).to eq 'http://www.apache.org/licenses/LICENSE-2.0.html'
      expect(info.version).to eq "1.0.1"
    end

    context 'with an invalid title' do
      before { payload['title'] = '' }

      it 'should raise an error' do
        expect { Swagger::Info.parse(payload) }.to raise_error(ArgumentError)
      end
    end
  end

  context 'when creating the object' do
    let(:info) do
      i = Swagger::Info.new
      i.title = "API Support"
      i.description = "Bazinga!"
      i.version = "7.4"
      i.license = Swagger::License.new
      i.license.name = "MIT"
      i.license.url = "http://mit.com/mit.html"

      i
    end

    it 'should convert it to a valid JSON' do
      obj = OpenStruct.new JSON.parse(info.to_json)

      expect(obj.title).to eq "API Support"
      expect(obj.description).to eq "Bazinga!"
      expect(obj.version).to eq "7.4"
      expect(obj.license['name']).to eq 'MIT'
      expect(obj.license['url']).to eq 'http://mit.com/mit.html'
    end

    it 'should convert it to a valid YAML' do
      obj = OpenStruct.new YAML.load(info.to_yaml)

      expect(obj.title).to eq "API Support"
      expect(obj.description).to eq "Bazinga!"
      expect(obj.version).to eq "7.4"
      expect(obj.license[:name]).to eq 'MIT'
      expect(obj.license[:url]).to eq 'http://mit.com/mit.html'
    end
  end




end