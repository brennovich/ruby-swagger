require 'spec_helper'
require 'yaml'
require 'ruby-swagger/io/file_system'

module Swagger::IO

end

describe Swagger::IO::FileSystem do

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
      FileUtils.rm_rf('./doc') if Dir.exists?('./doc') #cleanup
    end

    let(:filesystem) { Swagger::IO::FileSystem.new(document) }

    it 'should convert the document into a folder/file structure' do
      filesystem.write!

      expect(Dir.exists?('./doc')).to be_truthy
    end
  end

  context 'when loading data' do
    #NOT IMPLEMENTED
  end

  context 'when compiling data' do
    #NOT IMPLEMENTED
  end

end