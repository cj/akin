module Akin
  module Plugins
    module Client
      def self.included(klass)
        puts klass
      end

      module ClassMethods
        def render(method, *options, &block)
          new.render(method, *options, &block)
        end
      end

      module InstanceMethods
        def render(method, *options, &block)
          %{#{public_send(method, *options, &block)}}
        end
      end
    end

    register :client, Client
  end
end
