module Akin
  module Plugins
    module Client
      module ClassMethods
        def render(method)
          method.to_s
        end
      end
    end

    register :client, Client
  end
end
