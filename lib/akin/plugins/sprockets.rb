module Akin
  module Plugins
    module Sprockets
      def self.configure(akin, options = {})
        opts = akin.opts[:sprockets] ||= {
          debug: false,
          prefix: 'assets',
          maps_prefix: '__OPAL_SOURCE_MAPS__',
          app_dir: Dir.pwd,
          js_dir: 'app/assets/js',
          css_dir: 'app/assets/css'
        }

        opts.merge! options

        opts[:server] = Opal::Server.new do |s|
          s.append_path "#{opts[:app_dir]}/#{opts[:js_dir]}"
          s.append_path "#{opts[:app_dir]}/#{opts[:css_dir]}"

          Opal.paths.each do |p|
            s.append_path p
          end

          RailsAssets.load_paths.each do |p|
            s.append_path p
          end if defined?(RailsAssets)
        end.sprockets
      end unless RUBY_ENGINE == 'opal'

      module ClassMethods
        def update_sprocket_maps
          sprocket_opts[:maps] = Opal::SourceMapServer.new(sprocket_opts[:server],"/#{sprocket_opts[:maps_prefix]}")
          # Monkeypatch sourcemap header support into sprockets
          Opal::Sprockets::SourceMapHeaderPatch.inject!("/#{sprocket_opts[:maps_prefix]}")
        end

        def sprocket_opts
          Akin.opts[:sprockets]
        end

        def sprockets_maps
          sprocket_opts[:maps]
        end

        def sprockets_maps_prefix
          sprocket_opts[:maps_prefix]
        end

        def sprockets_prefix
          update_sprocket_maps if sprocket_opts[:debug]
          sprocket_opts[:prefix]
        end

        def sprockets_server
          sprocket_opts[:server]
        end

        def stylesheet_include_tag(name, options = {})
          name      = "#{name}.css"
          sprockets = sprocket_opts[:server]
          prefix    = sprocket_opts[:prefix]
          debug     = options[:debug] || sprocket_opts[:debug]

          # Avoid double slashes
          prefix = prefix.chop if prefix.end_with? '/'

          asset = sprockets[name]
          raise "Cannot find asset: #{name}" if asset.nil?
          stylesheets = []

          if debug
            asset.to_a.map do |dependency|
              stylesheets << %{<link rel="stylesheet" type="text/css" href="#{prefix}/#{dependency.logical_path}?body=1"></link>}
            end
          else
            stylesheets << %{<link rel="stylesheet" type="text/css" href="#{prefix}/#{name}"></link>}
          end

          stylesheets.join "\n"
        end

        def javascript_include_tag(file, options = {})
          Opal::Sprockets.javascript_include_tag(file,
            sprockets: sprockets_server,
            prefix: "/#{sprockets_prefix}", debug: options[:debug] || sprocket_opts[:debug]
          )
        end
      end
    end

    register(:sprockets, Sprockets)
  end
end unless RUBY_ENGINE == 'opal'
