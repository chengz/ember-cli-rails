require "cocaine"

module EmberCli
  class Command
    def initialize(paths:, options: {})
      @paths = paths
      @options = options
    end

    def test
      line = Cocaine::CommandLine.new(paths.ember, "test --environment test")

      line.command
    end

    def build(watch: false)
      ember_build(watch: watch)
    end

    private

    attr_reader :options, :paths

    def process_watcher
      options.fetch(:watcher) { EmberCli.configuration.watcher }
    end

    def silent?
      options.fetch(:silent) { false }
    end

    def ember_build(watch: false)
      line = Cocaine::CommandLine.new(paths.ember, [
        "build",
        ("--watch" if watch),
        ("--watcher :watcher" if process_watcher),
        ("--silent" if silent?),
        "--environment :environment",
        "--output-path :output_path",
      ].compact.join(" "))

      line.command(
        environment: EmberCli.env,
        output_path: paths.dist,
        watcher: process_watcher,
      )
    end
  end
end
