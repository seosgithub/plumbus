require 'active_support/inflector'

#Contains the class for each port
module Plumbus
  class Port
    SUPPORTED_DIRECTIONS = [:request, :response]

    attr_reader :driver_module_klass, :direction

    def initialize driver_module_klass:, direction:
      @driver_module_klass = driver_module_klass
      @direction = direction

      #@driver = Plumbus::PortDriver.new
      extend DriverFacilities
      extend "#{@driver_module_klass.name}::PlumbusHandlers".constantize
    end

    def attach!
      Ports.attach_port self
    end

    #def detach!
      #Ports.detach_port self
    #end

    def opposite_direction
      @direction == :request ? :response : :request
    end
  end

  class PortDriver
    #Plumbus extended handlers
    ###############################################################
    def config &block
    end

    #Forward a message to the block for a sid
    def forward_message sid, action, info
    end

    #Forward a signal, like disconnection
    def forward_signal signal, info
    end

    def supported_actions
      return @supported_actions
    end
    ###############################################################
  end
end
