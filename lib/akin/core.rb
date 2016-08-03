module Akin
  module Core
    def self.included(klass)
      klass.extend ClassMethods
    end

    module ClassMethods
      def plugin(plugin, *args, &block)
        raise AkinError, "Cannot add a plugin to a frozen Akin class" if frozen?
        plugin = Plugins.load_plugin(plugin) if plugin.is_a?(Symbol)
        plugin.load_dependencies(self, *args, &block) if plugin.respond_to?(:load_dependencies)
        include(plugin::InstanceMethods) if defined?(plugin::InstanceMethods)
        extend(plugin::ClassMethods) if defined?(plugin::ClassMethods)
        plugin.configure(self, *args, &block) if plugin.respond_to?(:configure)
        nil
      end

      def plugins(*plugins)
        plugins.each { |p| plugin p }
      end
    end
  end
end
