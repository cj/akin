require 'roda'
require 'akin'

# assets
require 'sass'
require 'rails-assets-jquery'
require 'rails-assets-todomvc-app-css'
require 'rails-assets-todomvc-common'

Akin.plugin :sprockets, debug: true

class App < Roda
  Unreloader.require('./app/plugins'){}
  Unreloader.require('./app/components'){}

  route do |r|
    r.on(Akin.sprockets_prefix)      { r.run Akin.sprockets_server }
    r.on(Akin.sprockets_maps_prefix) { r.run Akin.sprockets_maps }

    r.root do
      App::Components::Layout.render :display
    end
  end
end
