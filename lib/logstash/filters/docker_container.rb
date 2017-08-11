# encoding: utf-8
require 'logstash/filters/base'
require 'logstash/namespace'
require 'logstash/filters/docker_container/docker_container_inspector'
require 'json'

class LogStash::Filters::DockerContainer < LogStash::Filters::Base

  config_name "docker_container"
  
  config :match, :validate => :hash, :default => {'container_id' => 'container_name'}, :required => true

  config :docker_client, :validate => :string, :default => 'docker'

  config :client_options, :validate => :string, :default => ''

  public
  def register
    # Add instance variables
    @inspector = LogStash::Filters::DockerContainerSupport::DockerContainerInspector.new(@docker_client, @client_options)
    @cached = Hash.new
  end # def register

  public
  def filter(event)
    return unless filter? event

    @match.each { |in_field,out_field|
      event.set(out_field, resolve_from(event.get(in_field)))
    }

    filter_matched(event)
  end

  def resolve_from(container_id)
    if @cached.has_key?(container_id)
      return @cached[container_id]
    end

    blob = @inspector.inspect container_id
    details = JSON.parse(blob)

    return nil if details.empty?

    detail = details.first
    @cached[container_id] = detail['Name']

  end # def filter
end
