require 'yaml'
require 'erb'

module RailsConfig
  module Sources
    class YAMLSource
      attr_accessor :path, :namespace

      def initialize(path, namespace=nil)
        @path = path
        @namespace = namespace
      end

      # returns a config hash from the YML file
      def load
        if @path and File.exists?(@path.to_s)
          result = YAML.load(ERB.new(IO.read(@path.to_s)).result)
          if self.namespace
            namespaces = self.namespace.split("/")
            result = namespaces.reverse.inject(result || {}) { |acc, space| { space => acc } }
          end
        end
        result || {}
      rescue Psych::SyntaxError => e
        raise "YAML syntax error occurred while parsing #{@path}. " \
              "Please note that YAML must be consistently indented using spaces. Tabs are not allowed. " \
              "Error: #{e.message}"
      end
    end
  end
end
