module Akin
  module Plugins
    module Client
      unless RUBY_ENGINE == 'opal'
        def self.configure(klass, options = {})
          opts      = Akin.opts[:client] ||= { files: { default: [] } }
          file_path = caller[4][/[^:]*/]
          file_path = file_path.sub(Dir.pwd, '')[1..-1]

          opts[:files][options[:key]] ||= [] if options.key?(:key)

          client_files = Akin.opts[:client][:files][options[:key] || :default] << file_path
          options.fetch(:files) { [] }.each { |file| client_files << file }
        end

        module AkinClassMethods
          def client_files(key = false)
            files        = []
            plugin_files = Akin::Plugins.plugins.hash.map { |name, plugin| plugin[:file_path]}

            (plugin_files + Akin.opts[:client][:files][key || :default]).each do |file_path|
              files << file_path
            end

            files
          end
        end

        module ClassMethods
          def render(method, *options, &block)
            new.render(method, *options, &block)
          end
        end

        module InstanceMethods
          def render(method, *options, &block)
            response = public_send(method, *options, &block)
            code     = Opal::Compiler.new(%{
              Document.ready? do
                klass = #{self.class.name}.new

                if klass.respond_to?(:#{method})
                  klass.__send__(:#{method}, #{options.to_client})
                end
              end
            }).compile

            "#{response} <script>#{code}</script>"
          end
        end
      end
    end

    register :client, Client
  end
end

unless RUBY_ENGINE == 'opal'
  [Object, Array, FalseClass, Float, Hash, Integer, NilClass, String, TrueClass].each do |klass|
    klass.class_eval <<-RUBY, __FILE__, __LINE__
      def to_client(options = nil)
        "*JSON.parse(Base64.decode64('\#{Base64.encode64 self.to_json(options)}'))"
      end
    RUBY
  end
end
