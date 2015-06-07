require 'spec_helper'
require 'yaml'
require 'ruby-swagger/io/file_system'

describe Swagger::IO::FileSystem do

  DOC_PATH = "#{File.dirname(__FILE__)}/../../doc/"

  before do
    Swagger::IO::FileSystem.default_path = DOC_PATH
  end

  context 'with invalid format' do
    it 'should raise an argument error' do
      expect{ Swagger::IO::FileSystem.new(OpenStruct.new, :bazinga) }.to raise_error(ArgumentError)
    end
  end

  context 'when saving data' do
    let(:document) do
      File.open("#{File.dirname(__FILE__)}/../../fixtures/petstore/json/petstore-with-external-docs.json", 'r').read
    end

    after do
      FileUtils.rm_rf(DOC_PATH) if Dir.exists?(DOC_PATH) #cleanup
    end

    let(:filesystem) { Swagger::IO::FileSystem.new(document) }

    it 'should convert the document into a folder/file structure' do
      filesystem.write!

      expect(Dir.exists?(DOC_PATH)).to be_truthy
    end
  end

  context 'when loading data' do
    #NOT IMPLEMENTED
  end

  context 'when compiling data' do
    #NOT IMPLEMENTED
  end

end