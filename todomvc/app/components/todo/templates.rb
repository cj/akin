class App
  module Components
    class TodoTemplates
      include Akin::Core

      plugin :template, key: 'App::Components::Todo'

      attr_reader :dom

      def initialize(dom)
        @dom = dom
      end

      # create all the templates for todo
      def all
        self.class.instance_methods(false).each do |method|
          next if %i`all dom`.include? method
          send(method)
        end
      end

      def header
        dom.find('script, link').remove

        head = dom.find('head')
        html = dom.find('html')

        # todo: figure out why sprockets adds a delay to reload
        head.append Akin.stylesheet_include_tag 'app'
        html.append Akin.javascript_include_tag 'app'
      end

      def todo_list
        # save the list
        template :todo_list, dom.find('.todo-list') do |todo_dom|
          # save a todo item and set default styling
          template :todo_item, todo_dom.find('li:first-child') do |todo_item|

          end
          # remove the rest of the todo items
          todo_dom.find('li').remove
        end
      end
    end
  end
end
