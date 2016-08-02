require 'akin/opal'

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

        opts[:maps] = Opal::SourceMapServer.new(opts[:server], opts[:maps_prefix])

        # Monkeypatch sourcemap header support into sprockets
        ::Opal::Sprockets::SourceMapHeaderPatch.inject!(opts[:maps_prefix])
      end unless RUBY_ENGINE == 'opal'

      module ClassMethods
        def sprocket_opts
          Akin.opts[:sprockets]
        end

        def sprockets_maps_prefix
          sprocket_opts[:maps_prefix]
        end

        def sprockets_prefix
          sprocket_opts[:prefix]
        end

        def sprockets_server
          sprocket_opts[:server]
        end
      end
    end

    register(:sprockets, Sprockets)
  end
end
