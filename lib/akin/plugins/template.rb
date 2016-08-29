module Akin
  module Plugins
    module Template
      def self.load_dependencies(klass, options = {})
        klass.plugin :dom
      end

      def self.configure(_klass, options = {})
        Akin.opts[:template] ||= {}
      end

      module ClassMethods
        def template_file(*args, &block)
          new.template_file(*args, &block)
        end
      end

      module InstanceMethods
        def template_opts
          Akin.opts[:template][self.class.to_s] ||= {}
        end

        def template_file(name, file_path, &block)
          template(name, File.read(file_path), &block) unless RUBY_ENGINE == 'opal'
        end

        def template(name, value = false, &block)
          if !value
            template_opts[name.to_sym]
          else
            template_opts[name.to_sym] ||= if block_given?
              template_dom = value.is_a?(Dom::Instance) ? value : dom(value)
              instance_exec(template_dom, &block)
              template_dom.remove.to_html
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
