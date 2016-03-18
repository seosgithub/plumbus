require 'fileutils'

module Plumbus
  module FileGenerators
    def self.new_project path
      FileUtils.mkdir_p path
      Dir.chdir path do
        File.open "Gemfile", "w" do |f|
          f.puts <<HERE
source 'https://rubygems.org'
gem 'plumbus'
HERE
        end

        File.open "routes.rb", "w" do |f|
          f.puts <<HERE
port(:request, 'plumbus_http') do
  #Driver specific config
end

port(:response, 'plumbus_sockio') do
  #Driver specific config
end
HERE
        end
      end
    end
  end
end
