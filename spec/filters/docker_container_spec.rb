require 'spec_helper'
require "logstash/filters/docker_container"
require 'rspec/mocks'

describe LogStash::Filters::DockerContainer do
  let(:inspector) { double 'LogStash::Filters::DockerContainerSupport::DockerContainerInspector' }

  before do
    allow(LogStash::Filters::DockerContainerSupport::DockerContainerInspector).to receive(:new).and_return(inspector)
  end

  describe "typical case" do
    let(:config) do <<-CONFIG
      filter {
        docker_container {
          match => { 'container_id' => 'container_name' }
        }
      }
    CONFIG
    end

    before do
      content = File.new(File.join(File.dirname(__FILE__),'container_logstash.json')).read()
      expect(inspector).to receive(:inspect)
                               .with('bd30193a3b9d')
                               .and_return(content)
    end

    sample('container_id' => 'bd30193a3b9d') do
      expect(subject).to include('container_name')
      expect(subject['container_name']).to eq('/logstash')
    end
  end
end
