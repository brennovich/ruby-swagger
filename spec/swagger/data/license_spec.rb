require 'spec_helper'
require 'yaml'

describe Swagger::Data::License do

  let(:payload) do
    {
        "name"=> "Apache 2.0",
        "url"=> "http://www.apache.org/licenses/LICENSE-2.0.html"
    }
  end

  context 'with no options' do
    it 'should create a default license' do
      license = Swagger::Data::License.parse(payload)

      expect(license.name).to eq 'Apache 2.0'
      expect(license.url).to eq 'http://www.apache.org/licenses/LICENSE-2.0.html'
    end
  end

  context 'when parsing' do
    it 'should create a valid Swagger::Data::License' do
      license = Swagger::Data::License.parse(payload)

      expect(license.name).to eq 'Apache 2.0'
      expect(license.url).to eq 'http://www.apache.org/licenses/LICENSE-2.0.html'
    end

    context 'with an invalid url' do
      before { payload['url'] = 'bazinga!' }

      it 'should raise an error' do
        expect { Swagger::Data::License.parse(payload) }.to raise_error(ArgumentError)
      end
    end
  end

  context 'when creating the object' do
    let(:license) do
      l = Swagger::Data::License.new
      l.name = "MIT"
      l.url = "http://mit.com/mit.html"
      l
    end

    it 'should convert it to a valid JSON' do
      obj = OpenStruct.new JSON.parse(license.to_json)

      expect(obj.name).to eq 'MIT'
      expect(obj.url).to eq 'http://mit.com/mit.html'
    end

    it 'should convert it to a valid YAML' do
      obj = OpenStruct.new YAML.load(license.to_yaml)

      expect(obj.name).to eq 'MIT'
      expect(obj.url).to eq 'http://mit.com/mit.html'
    end
  end

end