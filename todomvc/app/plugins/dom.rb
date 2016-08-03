require 'opal-jquery'
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
          @dom   = opts[:dom]

          if html = opts[:html]
            @dom = RUBY_ENGINE == 'opal' ? Element[html] : Nokogiri::HTML(html)
          end
        end

        # this is where we add methods to nokogiri that are included in jquery.
        if RUBY_ENGINE != 'opal'
          def find(selector)
            Instance.new(scope, dom: dom.css(selector))
          end
        end

        def to_s
          dom.to_s
        end

        def method_missing(method, *args, &block)
          if dom.respond_to?(method, true)
            Instance.new(scope, dom: dom.send(method, *args, &block))
          else
            super
          end
        end
      end
    end

    register :dom, Dom
  end
end
