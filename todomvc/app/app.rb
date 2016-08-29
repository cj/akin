require 'roda'
require 'akin'

# assets
require 'sass'
require 'rails-assets-jquery'
require 'rails-assets-todomvc-app-css'
require 'rails-assets-todomvc-common'

Akin.plugin :sprockets, debug: true

class App < Roda
  plugin :environments

  configure :development do
    require 'pry'
    require 'awesome_print'
  end

  Dir['./app/components/**/*.rb'].sort.each { |rb| require rb }

  # gzips assets
  use Rack::Deflater, include: %w{text/plain application/xml application/json application/javascript text/css text/json}

  route do |r|
    r.on(Akin.sprockets_maps_prefix) { r.run Akin.sprockets_maps }
    r.on(Akin.sprockets_prefix)      { r.run Akin.sprockets_server }

    r.root do
      App::Components::Todo.render :display
    end
  end
end
