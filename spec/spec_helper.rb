$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'plumbus'

Dir["./spec/support/**/*.rb"].each do |f|
 puts f
  load f
end

RSpec.configure do |config|
  config.order = "random"
end
