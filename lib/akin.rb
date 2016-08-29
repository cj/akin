# frozen-string-literal: true

require "akin/opal" if RUBY_ENGINE == 'opal'
require "akin/version"
require "akin/cache"
require "akin/core"
require "akin/plugins"

module Akin
  include Core

  autoload :Opal, 'akin/opal'

  DIR_PATH = File.expand_path('..', __FILE__)

  # Error class raised by Akin
  class Error < StandardError; end

  def self.opts
    @opts ||= Cache.new
  end
end
