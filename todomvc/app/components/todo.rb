require_relative 'todo/client'
require_relative 'todo/server' unless RUBY_ENGINE == 'opal'

class App
  module Components
    class Todo
      include Akin::Core

      plugin :client, files: %w'app/components/todo/client'
      plugin :template

      include RUBY_ENGINE == 'opal' ? TodoClient : TodoServer

      template_file :html, './app/views/index.html' do |dom|
        require_relative 'todo/templates'
        TodoTemplates.new(dom).all
      end
    end
  end
end
