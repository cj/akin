# frozen-string-literal: true

require "akin/opal" if RUBY_ENGINE == 'opal'
require "akin/version"
require "akin/cache"
require "akin/core"
require "akin/plugins"

module Akin
  include Core

  # Error class raised by Akin
  class Error < StandardError; end

  def self.opts
    @opts ||= Cache.new
  end

  extend Core::ClassMethods
end
