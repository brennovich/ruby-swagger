require 'spec_helper'

require_relative '../grape/application_entity'
require_relative '../grape/application_api'

describe Grape::DSL::Configuration do

  context 'with no overridden default values' do

    subject { ApplicationsAPI.routes.first }

    it 'should inspect extended parameters for Grape' do
      expect(subject.route_company_authenticated).to be_truthy
      expect(subject.route_user_authenticated).to be_truthy
      expect(subject.route_scopes).to eq ['application:read']
      expect(subject.route_tags).to eq ['applications']
      expect(subject.route_deprecated).to be_truthy
      expect(subject.route_hidden).to be_truthy
      expect(subject.route_result).to eq ApplicationEntity
      expect(subject.route_result_root).to eq 'applications'
      expect(subject.route_errors).to eq({
                                             '300' => 'Redirected',
                                             '404' => 'Not found',
                                             '501' => 'WTF?',
                                             '418' => 'I\'m a teapot'
                                         })
    end

  end


end