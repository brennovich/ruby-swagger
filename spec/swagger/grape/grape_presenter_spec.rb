require 'spec_helper'

require 'rack/test'
require_relative '../../fixtures/grape/applications_api'

describe Grape::DSL::InsideRoute do
  include Rack::Test::Methods

  def app
    ApplicationsAPI
  end

  describe 'api_present' do
    let(:applications) { JSON.parse(last_response.body)['applications'] }

    it 'should return a formatted ApplicationEntity' do
      get 'api/v1/applications/'
      expect(last_response.status).to eq(200)
      expect(applications.count).to eq 2
      expect(applications.first['id']).to eq '123456'
      expect(applications.last['id']).to eq '654321'
    end
  end
end
