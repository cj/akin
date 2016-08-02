dev = ENV['RACK_ENV'] == 'development'

if dev
  require 'logger'
  logger = Logger.new($stdout)
end

require 'rack/unreloader'
Unreloader = Rack::Unreloader.new(:subclasses=>%w'Roda Akin Sequel::Model', :logger=>logger, :reload=>dev){App}
Unreloader.require('app/app.rb'){'App'}
run(dev ? Unreloader : App.freeze.app)
