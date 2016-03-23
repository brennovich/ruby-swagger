require 'spec_helper'

require_relative '../../fixtures/grape/applications_api'

describe Grape::DSL::Configuration do
  context 'with no overridden default values' do
    subject { ApplicationsAPI.routes.first }

    it 'should inspect extended parameters for Grape' do
      expect(subject.route_headers).to eq({ 'Authorization' => { description: "A valid user session token, in the format 'Bearer TOKEN'", required: true } })
      expect(subject.route_api_name).to eq 'get_applications'
      expect(subject.route_detail).to eq 'This API does this and that and more'
      expect(subject.route_scopes).to eq ['application:read']
      expect(subject.route_tags).to eq ['applications']
      expect(subject.route_deprecated).to be_truthy
      expect(subject.route_hidden).to be_falsey
      expect(subject.route_response).not_to be_nil
      expect(subject.route_response[:entity]).to eq ApplicationEntity
      expect(subject.route_response[:root]).to eq 'applications'
      expect(subject.route_response[:headers]).to eq({ 'X-Request-Id' => { description: 'Unique id of the API request', type: 'string' },
                                                       'X-Runtime' => { description: 'Time spent processing the API request in ms', type: 'string' },
                                                       'X-Rate-Limit-Limit' => { description: 'The number of allowed requests in the current period', type: 'integer' },
                                                       'X-Rate-Limit-Remaining' => { description: 'The number of remaining requests in the current period', type: 'integer' },
                                                       'X-Rate-Limit-Reset' => { description: 'The number of seconds left in the current period', type: 'integer' } })
      expect(subject.route_errors).to eq({ '300' => { entity: ErrorRedirectEntity, description: 'You will be redirected' },
                                           '404' => { entity: ErrorNotFoundEntity, description: 'The document is nowhere to be found' },
                                           '501' => { entity: ErrorBoomEntity, description: 'Shit happens' },
                                           '418' => { entity: ErrorBoomEntity, description: 'Yes, I am a teapot' } })
    end
  end
end
