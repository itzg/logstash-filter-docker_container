Gem::Specification.new do |s|
  s.name = 'logstash-filter-docker_container'
  s.version = '0.2.3'
  s.licenses      = ['Apache-2.0']
  s.summary = "Resolves Docker container IDs into the container's name."
  s.description = "With Docker's syslog log-driver the log entries contain just container ID, but seeing the name is even better"
  s.authors = ["Geoff Bourne"]
  s.email = 'itzgeoff@gmail.com'
  s.homepage = "https://github.com/itzg/logstash-filter-docker_container"
  s.require_paths = ["lib"]

  # Files
  s.files = Dir['lib/**/*','spec/**/*','vendor/**/*','*.gemspec','*.md','CONTRIBUTORS','Gemfile','LICENSE','NOTICE.TXT']
  # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "filter" }

  # Gem dependencies
  s.add_runtime_dependency "logstash-core", '>= 5.0.0', '< 9.0.0'
  s.add_runtime_dependency "logstash-core-plugin-api", "~> 2.0"
  s.add_development_dependency 'logstash-devutils'
end
