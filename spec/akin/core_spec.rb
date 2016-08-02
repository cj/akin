# require 'spec_helper'
#
# module BarPlugin
#   module ClassMethods
#     def bar
#       true
#     end
#   end
#
#   module InstanceMethods
#     def bar
#       true
#     end
#   end
#
#   Akin::Plugins.register :bar, BarPlugin
# end
#
# class Foo
#   include Akin::Core
#
#   plugin :bar
# end
#
# describe Akin::Core do
#   it '#plugin' do
#     expect(Foo).to respond_to(:plugin)
#     expect(Foo.bar).to eq true
#     expect(Foo.new.bar).to eq true
#   end
# end
