require 'spec_helper'

require_relative '../grape/application_entity'
require_relative '../grape/application_api'

describe Grape::DSL::Configuration do

  context 'with no overridden default values' do

    subject { ApplicationsAPI.routes.first }

    it 'should inspect extended parameters for Grape' do
      expect(subject.route_headers).to eq({"Authorization"=>{:description=>"A valid user session token, in the format 'Bearer TOKEN'", :required=>true}})
      expect(subject.route_api_name).to eq 'get_applications'
      expect(subject.route_detail).to eq 'This API does this and that and more'
      expect(subject.route_scopes).to eq ['application:read']
      expect(subject.route_tags).to eq ['applications']
      expect(subject.route_deprecated).to be_truthy
      expect(subject.route_hidden).to be_falsey
      expect(subject.route_result).to eq ApplicationEntity
      expect(subject.route_result_root).to eq 'applications'
      expect(subject.route_errors).to eq({"300"=>{:message=>"Redirected", :description=>"You will be redirected"},
                                          "404"=>{:message=>"Not found", :description=>"The document is nowhere to be found"},
                                          "501"=>{:message=>"WTF?", :description=>"Shit happens"},
                                          "418"=>{:message=>"I'm a teapot", :description=>"Yes, I am"}})
    end

  end


end