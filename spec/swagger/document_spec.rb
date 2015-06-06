require 'spec_helper'

describe Swagger::Document do

  context 'as an empty document' do
    subject { OpenStruct.new(JSON.parse(Swagger::Document.new.to_json)) } #encoding and decoding - like a client would

    it 'should have a valid version' do
      expect(subject.swagger).to eq '2.0'
    end
  end

end