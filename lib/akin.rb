# frozen-string-literal: true

require "akin/version"

module Akin
  # Error class raised by Akin
  class AkinError < StandardError; end

  autoload :Core,    'akin/core'
  autoload :Plugins, 'akin/plugins'
  autoload :Cache,   'akin/cache'
  autoload :Opal,    'akin/opal'
end
