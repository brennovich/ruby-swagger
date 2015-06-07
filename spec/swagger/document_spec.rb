require 'spec_helper'

describe Swagger::Document do

  context 'as an empty document' do
    subject { OpenStruct.new(JSON.parse(Swagger::Document.new.to_json)) } #encoding and decoding - like a client would

    it 'should have a valid version' do
      expect(subject.swagger).to eq '2.0'
      expect(subject.info['title']).to eq 'My uber-duper API'
      expect(subject.info['description']).to eq 'My uber-duper API description'
      expect(subject.info['version']).to eq '0.1'
    end
  end

  context 'with a payload' do
    let(:payload) do
      json = File.open("#{File.dirname(__FILE__)}/../fixtures/petstore/json/petstore-with-external-docs.json", 'r').read
      JSON.parse(json)
    end

    context 'when parsing' do
      it 'should create a valid Swagger::Document' do
        doc = Swagger::Document.parse(payload)

        expect(doc.swagger).to eq "2.0"
        expect(doc.schemes).to eq ['http']
        expect(doc.consumes).to eq ['application/json']
        expect(doc.produces).to eq ['application/json']

        expect(doc.host).to eq 'petstore.swagger.io'
        expect(doc.basePath).to eq '/api'

        expect(doc.info.version).to eq "1.0.0"
        expect(doc.info.title).to eq "Swagger Petstore"
        expect(doc.info.description).to eq "A sample API that uses a petstore as an example to demonstrate features in the swagger-2.0 specification"
        expect(doc.info.termsOfService).to eq "http://swagger.io/terms/"
        expect(doc.info.contact.name).to eq "Swagger API Team"
        expect(doc.info.contact.email).to eq "apiteam@swagger.io"
        expect(doc.info.contact.url).to eq "http://swagger.io"
        expect(doc.info.license.name).to eq "MIT"
        expect(doc.info.license.url).to eq "http://github.com/gruntjs/grunt/blob/master/LICENSE-MIT"

      end

      context 'with an invalid title' do
        before { payload['info']['title'] = '' }

        it 'should raise an error' do
          expect { Swagger::Document.parse(payload) }.to raise_error(ArgumentError)
        end
      end
    end

  end


end