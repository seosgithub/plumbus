require 'active_support/inflector'

module Plumbus
  module Driver
    #Available drivers
    @@link_table = {}

    def self.load driver_name
      require driver_name.to_s

      return self.add_link driver_name
    rescue LoadError => e
      raise LoadError, "Driver named #{driver_name.inspect} failed to load.  Are you sure it's installed correctly?: #{e.inspect}"
    end

    private

    def self.add_link name
      mod = name.to_s.classify.constantize
      @@link_table[name.to_sym] = mod
      $stderr.puts "[Driver #{name.inspect} linked]"

      return mod
    end

    def self.link_table() return @@link_table end
  end
end
