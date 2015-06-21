require 'spec_helper'

require 'rake'
load "#{File.dirname(__FILE__)}/../../lib/tasks/swagger.rake"
require_relative 'grape/application_api'


describe 'Ruby::Swagger' do

  def no_stdout
    $stdout = StringIO.new
  end

  def open_yaml(file)
    YAML::load_file(file)
  end

  before do
    FileUtils.rm_rf("./doc/swagger")
  end

  # after do
  #   FileUtils.rm_rf("./doc/swagger")
  # end

  describe 'rake swagger:grape:generate_doc' do

    let(:rake_task) { Rake::Task['swagger:grape:generate_doc'] }

    before do
      rake_task.reenable
      no_stdout
      rake_task.invoke('ApplicationsAPI')
    end

    it 'should generate a base_doc.yaml' do
      expect(File.exists?("./doc/swagger/base_doc.yaml")).to be_truthy
    end

    it 'base_doc.yaml contains valid information' do
      base_doc = open_yaml "./doc/swagger/base_doc.yaml"
      expect(base_doc['swagger']).to eq '2.0'
      expect(base_doc['info']['title']).to eq 'My uber-duper API'
      expect(base_doc['info']['description']).to eq 'My uber-duper API description'
      expect(base_doc['info']['termsOfService']).to eq 'https://localhost/tos.html'

      expect(base_doc['info']['contact']['name']).to eq 'John Doe'
      expect(base_doc['info']['contact']['email']).to eq 'john.doe@example.com'
      expect(base_doc['info']['contact']['url']).to eq 'https://google.com/?q=john%20doe'

      expect(base_doc['info']['license']['name']).to eq 'Apache 2.0'
      expect(base_doc['info']['license']['url']).to eq 'http://www.apache.org/licenses/LICENSE-2.0.html'

      expect(base_doc['info']['version']).to eq '0.1'

      expect(base_doc['host']).to eq 'localhost:80'
      expect(base_doc['basePath']).to eq '/api/v1'
      expect(base_doc['schemes']).to eq ['https', 'http']
      expect(base_doc['consumes']).to eq ['application/json']
      expect(base_doc['produces']).to eq ['application/json']
    end

    it 'should generate a paths folder' do
      expect(Dir.exists?('./doc/swagger/paths')).to be_truthy
    end

    it 'should generate a ./doc/swagger/paths/applications/get.yaml file' do
      expect(File.exists?('./doc/swagger/paths/applications/get.yaml')).to be_truthy
    end

    it 'should include information about deprecation in applications/get.yaml' do
      expect(open_yaml('./doc/swagger/paths/applications/get.yaml')['deprecated']).to be_truthy
    end

    it 'should include tags information in applications/get.yaml' do
      expect(open_yaml('./doc/swagger/paths/applications/get.yaml')['tags']).to eq(['applications'])
    end

    it 'should include tags information in applications/{id}/check_access/get.yaml' do
      expect(open_yaml('./doc/swagger/paths/applications/{id}/check_access/get.yaml')['tags']).to eq(['applications', 'getter'])
    end

    it 'should include tags information in applications/{id}/post.yaml' do
      expect(open_yaml('./doc/swagger/paths/applications/{id}/post.yaml')['tags']).to eq(['applications', 'create', 'swag'])
    end

    # the endpoint is hidden - nothing to see here
    it 'should NOT generate a ./doc/swagger/paths/applications/{id}/get.yaml file' do
      expect(File.exists?('./doc/swagger/paths/applications/{id}/get.yaml')).to be_falsey
    end

    it 'should generate a ./doc/swagger/paths/applications/{id}/post.yaml file' do
      expect(File.exists?('./doc/swagger/paths/applications/{id}/post.yaml')).to be_truthy
    end

    it 'should generate a ./doc/swagger/paths/applications/{id}/delete.yaml file' do
      expect(File.exists?('./doc/swagger/paths/applications/{id}/delete.yaml')).to be_truthy
    end

    it 'should generate a ./doc/swagger/paths/applications/{id}/check_access/get.yaml file' do
      expect(File.exists?('./doc/swagger/paths/applications/{id}/check_access/get.yaml')).to be_truthy
    end

  end


end