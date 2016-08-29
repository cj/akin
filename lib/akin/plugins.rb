module Akin
  module Plugins
    extend self

    attr_reader :plugins

    # Stores registered plugins
    @plugins = Cache.new

    # If the registered plugin already exists, use it.  Otherwise,
    # require it and return it.  This raises a LoadError if such a
    # plugin doesn't exist, or a Error if it exists but it does
    # not register itself correctly.
    def load_plugin(name)
      h = @plugins

      unless plugin = h[name]
        begin
          require "akin/plugins/#{name}" unless RUBY_ENGINE == 'opal'
          plugin = h[name]
        rescue
          raise Error, "Plugin #{name} did not register itself correctly in Akin::Plugins" unless plugin = h[name]
        end
      end

      plugin[:mod]
    end

    # Register the given plugin with , so that it can be loaded using #plugin
    # with a symbol.  Should be used by plugin files. Example:
    #
    #   ::Plugins.register_plugin(:plugin_name, PluginModule)
    def register(name, mod)
      file_path = RUBY_ENGINE == 'opal' ? '' : caller[0][/[^:]*/].sub(DIR_PATH, '').sub(Dir.pwd, '')[1..-1]
      @plugins[name] = { mod: mod, file_path: file_path }
    end
  end
end
