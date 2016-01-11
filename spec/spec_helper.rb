require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'

RSpec.configure do |c|
  c.fail_fast     = true
  c.formatter     = :documentation
  c.default_facts = { concat_basedir: '/nonexistant' }
end

include RspecPuppetFacts

require 'simplecov'
require 'simplecov-console'

SimpleCov.start do
  add_filter '/spec'
  add_filter '/vendor'
  formatter SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::Console
  ])
end
