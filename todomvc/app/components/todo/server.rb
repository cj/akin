class App
  module Components
    module TodoServer
      def display
        todo_dom = dom(template :html)
        todo_dom
      end

      def moo
        'cow'
      end
    end
  end
end
