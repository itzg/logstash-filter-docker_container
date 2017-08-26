require 'spec_helper'
require "logstash/filters/docker_container"
require 'rspec/mocks'

describe LogStash::Filters::DockerContainer do
  let(:inspector) { double 'LogStash::Filters::DockerContainerSupport::DockerContainerInspector' }

  before do
    allow(LogStash::Filters::DockerContainerSupport::DockerContainerInspector).to receive(:new).and_return(inspector)
  end

  describe "typical case and cached" do
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
      # Due to caching of the Docker findings, the inspector should only be consulted once
      # since the sample includes the same container ID both times
      expect(inspector).to receive(:inspect).once
                               .with('bd30193a3b9d')
                               .and_return(content)
    end

    sample([{'seq' => 1, 'container_id' => 'bd30193a3b9d'}, {'seq' => 2, 'container_id' => 'bd30193a3b9d'}]) do
      subject.each do |e|
        expect(e).to include('container_name')
        expect(e.get('container_name')).to eq('/logstash')
      end
    end
  end
end
