require 'spec_helper'

unless RUBY_ENGINE == 'opal'
  describe 'Akin::Plugins::Sprockets' do
    before { Akin.plugin :sprockets }

    it "#sprockets_prefix" do
      expect(Akin).to respond_to :sprockets_prefix
    end
  end
end
