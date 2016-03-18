module Plumbus
  module FileGenerators
    def self.new_project path
      Dir.chdir path do
        File.open "Gemfile", "w" do |g|
          g.puts "source 'https://rubygems.org'"
          g.puts "gem 'plumbus'"
        end

        File.open "routes", "w" do |g|
          g << "#routes"
        end
      end
    end
  end
end
