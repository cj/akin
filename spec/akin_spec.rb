require 'spec_helper'

describe Akin do
  it 'has a version number' do
    expect(Akin::VERSION).not_to be nil
  end

  it '#plugin' do
    expect(Akin).to respond_to :plugin
  end

  it '#opts' do
    expect(Akin.opts).to be_kind_of Akin::Cache
  end
end
