require 'nokogiri' unless RUBY_ENGINE == 'opal'

module Akin
  module Plugins
    module Dom
      module InstanceMethods
        def dom(html = false)
          Instance.new(self, html: html)
        end
      end

      class Instance
        attr_reader :scope, :opts, :dom

        def initialize(scope, opts = {})
          @scope = scope
          @opts  = opts
          @dom   = if html = opts[:html]
            RUBY_ENGINE == 'opal' ? Element[html] : Nokogiri::HTML(html)
          else
            opts[:dom] || (RUBY_ENGINE == 'opal' ? Element['html'] : Nokogiri::HTML(''))
          end
        end

        # this is where we add methods to nokogiri that are included in jquery.
        if RUBY_ENGINE != 'opal'
          def find(selector)
            Instance.new(scope, dom: dom.css(selector))
          end

          def append(obj)
            dom.each { |node| node.children.last.add_next_sibling obj }
          end

          def prepend(obj)
            dom.each { |node| node.children.first.add_previous_sibling obj }
          end
        end

        def to_s
          dom.to_s
        end

        def method_missing(method, *args, &block)
          if dom.respond_to?(method, true)
            result = dom.send(method, *args, &block)

            if result.class.to_s['Nokogiri'] || result.class.to_s['Element']
              Instance.new(scope, dom: result)
            else
              result
            end
          else
            super
          end
        end
      end
    end

    register :dom, Dom
  end
end
