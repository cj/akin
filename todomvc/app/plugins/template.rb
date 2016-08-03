module Akin
  module Plugins
    module Template
      def self.load_dependencies(klass, options = {})
        klass.plugin :dom
      end

      def self.configure(_klass, options = {})
        Akin.opts[:template] = Cache.new
      end

      module InstanceMethods
        def template_opts
          Akin.opts[self.class.to_s] ||= Cache.new
        end

        def template_file(name, file_path, &block)
          template(name, File.read(file_path), &block) unless RUBY_ENGINE == 'opal'
        end

        def template(name, value = false, &block)
          if !value
            template_opts[name.to_sym]
          else
            template_opts[name.to_sym] ||= if block_given?
              template_dom = dom(value)
              instance_exec(template_dom, &block)
              template_dom.to_html
            else
              value
            end
          end
        end
      end
    end

    register :template, Template
  end
end
