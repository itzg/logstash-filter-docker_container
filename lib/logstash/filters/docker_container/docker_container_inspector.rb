
module LogStash::Filters::DockerContainerSupport

    class DockerContainerInspector

      public
      # @param [String] docker_client the Docker client executable to run. Either needs to be in $PATH or an absolute path
      # @param [String] client_options the command-line options to fine tune connectivity to the Docker daemon
      def initialize(docker_client, client_options)
        @docker_client = docker_client
        @client_options = client_options
      end

      public
      # @return [String] the `docker inspect` content or '[]' if unable to find the container
      # @param [String] container_id
      def inspect(container_id)
        content = `#{@docker_client} #{@client_options} inspect #{container_id}`
        return $?.success? ? content : '[]'
      end
    end

end
