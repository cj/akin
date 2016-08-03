class App
  module Components
    class Layout
      include Akin::Core

      plugins :template, :client

      def initialize
        template_file :layout, './app/views/index.html' do |template_dom|
          template_dom.find('script, link').remove
        end
      end

      def display
        layout_dom = dom(template :layout)
        layout_dom
      end
    end
  end
end
