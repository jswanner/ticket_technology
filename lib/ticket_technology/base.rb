module TicketTechnology
  class Base
    class Action
      attr_reader :name, :operation, :method, :service, :parser, :parameters

      def initialize(operation, options={}, &block)
        @name = options[:as] || operation
        @operation = (operation || options[:as]).to_s.camelcase.sub(/Id/, 'ID')
        @method = options[:method]
        @service = options[:service]
        @parser = options[:parser]
        @parameters = {}

        options[:defaults].each { |defaults| instance_eval(&defaults) }
        instance_eval(&block) if block_given?
      end

      # Adds a parameter that the web service accepts.
      def parameter(name, options={})
        @parameters[name] = options
      end

      def execute(*args)
        parameters = args.first || {}
        Request.new(self, parameters).perform
      end
    end

    class Request
      include TicketTechnology::FormatHelper

      def initialize(action, parameters)
        @action = action
        @parameters = HashWithIndifferentAccess.new(parameters)
      end

      # Executes the call to the web service.
      def perform
        uri = URI.parse(url)

        session = Patron::Session.new
        session.timeout = 60
        session.base_url = "#{uri.scheme}://#{uri.host}:#{uri.port}/"

        retries = 5

        begin
          response = case @action.method
            when :get
              session.get([uri.path, uri.query].compact.join('?'))
            when :post
              session.post(uri.path, uri.query)
          end
        rescue Patron::PartialFileError, Patron::ConnectionFailed, Patron::HostResolutionError, Patron::TimeoutError
          if (retries -= 1) > 0
            retry
          else
            puts $!.inspect
            raise #NetworkError.new($!.to_s)
          end
        end

        case body = response.body
          when /^Authorization error: IP ([\d\.]+)/
            raise AuthorizationError, "Unauthorized IP (#{$1})"
          when /must be SSL/
            raise AuthorizationError, 'SSL Required'
          when /^Missing parameter: (.*)\./
            raise ParameterError, "Missing #{$1}"
          when /^Parameter error: (.*): (.*)\./
            raise ParameterError, "Invalid #{$1} (#{$2})"
          when /\A(?!<\?xml)/
            raise Error, body
          else
            @action.parser.parse(body) if body
        end
      end

      def endpoint(service)
        case service
          when :checkout then CHECKOUT
          when :catalog then CATALOG
          else raise Error.new("Unknown endpoint for service #{service}")
        end
      end
      private :endpoint

      # Builds the base URL from the endpoint and operation. If the method is
      # GET, the query values are appended.
      def url
        base_url = "#{endpoint(@action.service)}/#{@action.operation}"
        base_url << "?#{query}" if @action.method == :get
        base_url
      end
      private :url

      # Builds the query string from the specified parameter values.
      def query
        @action.parameters.collect do |key, options|
          value = @parameters[options[:as] || key]
          value ||= options[:default] if options.include?(:default)

          "#{format_query_key(key)}=#{format_query_value(value)}"
        end.join('&')
      end
      private :query
    end

    class << self
      # Sets or returns the service.
      def service(service=nil)
        unless service
          read_inheritable_attribute(:service)
        else
          write_inheritable_attribute(:service, service)
        end
      end

      # Sets or returns action defaults.
      def defaults(&block)
        unless block
          read_inheritable_attribute(:defaults)
        else
          write_inheritable_array(:defaults, [block])
        end
      end

      # Creates a new GET operation.
      def get(operation, options={}, &block)
        action(operation, options.merge(:method => :get), &block)
      end

      # Creates a new POST operation.
      def post(operation, options={}, &block)
        action(operation, options.merge(:method => :post), &block)
      end

      # Creates a new operation.
      def action(operation, options={}, &block)
        options[:service] ||= service
        options[:defaults] ||= defaults
        options[:parser] ||= self::Parser
        action = Action.new(operation, options, &block)

        self.singleton_class.class_eval do
          define_method(action.name) do |*args|
            action.execute(*args)
          end
        end
      end
      private :action
    end

    defaults do
      parameter :user_name,   :default => TicketTechnology.user_name
      parameter :password,    :default => TicketTechnology.password
      parameter :domain_name, :default => TicketTechnology.domain_name
    end
  end
end
