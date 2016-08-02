require 'roda'
require 'akin'
require 'akin/opal'

# assets
require 'sass'
require 'rails-assets-jquery'
require 'rails-assets-todomvc-app-css'
require 'rails-assets-todomvc-common'

Akin.plugin :sprockets, debug: true

class App < Roda
  route do |r|
    r.on(Akin.sprockets_prefix)      { r.run Akin.sprockets_server }
    r.on(Akin.sprockets_maps_prefix) { r.run Akin.sprockets_maps }

    r.root do
      'todomvc'
    end
  end
end
