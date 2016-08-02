module Akin
  module Plugins
    # Stores registered plugins
    @plugins = Cache.new

    # If the registered plugin already exists, use it.  Otherwise,
    # require it and return it.  This raises a LoadError if such a
    # plugin doesn't exist, or a Error if it exists but it does
    # not register itself correctly.
    def self.load_plugin(name)
      h = @plugins

      unless plugin = h[name]
        begin
          require "akin/plugins/#{name}"
          plugin = h[name]
        rescue
          raise Error, "Plugin #{name} did not register itself correctly in Akin::Plugins" unless plugin = h[name]
        end
      end

      plugin
    end

    # Register the given plugin with , so that it can be loaded using #plugin
    # with a symbol.  Should be used by plugin files. Example:
    #
    #   ::Plugins.register_plugin(:plugin_name, PluginModule)
    def self.register(name, mod)
      @plugins[name] = mod
    end
  end
end
