require 'msgpack'

#Used by actual drivers
module Plumbus
  module DriverFacilities
    #This is imported into the Port (which is a driver) interface
    def invalidate_supported_actions
      Ports.refresh_port_routing_table self
    end

    def emit_message sid, action, payload
      Ports.forward_message port:self, sid:sid, action:action, payload:payload
    end

    def raise_signal name, info
      Ports.signal port:self, name:name, info:info
    end
  end
end
