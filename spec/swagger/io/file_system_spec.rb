require 'spec_helper'
require 'yaml'
require 'ruby-swagger/io/file_system'

describe Swagger::IO::FileSystem do

  DOC_PATH = "#{File.dirname(__FILE__)}/../../doc/"

  before do
    Swagger::IO::FileSystem.default_path = DOC_PATH
  end

  context 'when saving data' do
    let(:document) do
      File.open("#{File.dirname(__FILE__)}/../../fixtures/petstore/json/petstore-with-external-docs.json", 'r').read
    end

    after do
      FileUtils.rm_rf(DOC_PATH) if Dir.exists?(DOC_PATH) #cleanup
    end

    let(:filesystem) { Swagger::IO::FileSystem.new(Swagger::Document.parse(JSON.parse(document))) }

    it 'should convert the document into a folder/file structure' do
      filesystem.write!

      expect(Dir.exists?(DOC_PATH)).to be_truthy
      expect(File.exists?(DOC_PATH + '/base_doc.yaml')).to be_truthy

      swagger_doc = YAML.load_file(DOC_PATH + '/base_doc.yaml')

      expect(swagger_doc).not_to be_nil
      expect(swagger_doc['swagger']).to eq '2.0'

      expect(swagger_doc['host']).to eq 'petstore.swagger.io'
      expect(swagger_doc['basePath']).to eq '/api'

      expect(swagger_doc['info']['version']).to eq "1.0.0"

      expect(swagger_doc['info']['license']['name']).to eq "MIT"
      expect(swagger_doc['info']['license']['url']).to eq "http://github.com/gruntjs/grunt/blob/master/LICENSE-MIT"

      expect(swagger_doc['info']['title']).to eq "Swagger Petstore"
      expect(swagger_doc['info']['description']).to eq "A sample API that uses a petstore as an example to demonstrate features in the swagger-2.0 specification"
      expect(swagger_doc['info']['termsOfService']).to eq "http://swagger.io/terms/"

      expect(swagger_doc['info']['contact']['name']).to eq "Swagger API Team"
      expect(swagger_doc['info']['contact']['email']).to eq "apiteam@swagger.io"
      expect(swagger_doc['info']['contact']['url']).to eq "http://swagger.io"
    end
  end

  context 'when loading data' do
    #NOT IMPLEMENTED
  end

  context 'when compiling data' do
    #NOT IMPLEMENTED
  end

end