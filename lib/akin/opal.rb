require 'opal'
require 'opal-jquery'
require 'base64'

if RUBY_ENGINE != 'opal'
  Opal.append_path Akin::DIR_PATH
  Opal.append_path "#{Dir.pwd}/spec"
  Opal.append_path Dir.pwd
end
