#Ports manages the actual instances of the port classes
module Plumbus
  module Ports
    #Instances#########################################################
    #Holds instances
    @@instances = []
    def self.instances; @@instances end

    #Attach a port
    def self.attach_port port
      @@instances << port
      refresh_port_routing_table port
    end

    def self.refresh_port_routing_table port
      evict_routing_table_references port

      port.supported_actions.each do |action|
        action = action.to_s
        @@routing_table[port.opposite_direction][action] ||= []
        @@routing_table[port.opposite_direction][action] << port
      end
    end

    def self.evict_routing_table_references port
      @@routing_table[port.opposite_direction].remove_references! port
      @@routing_table[port.opposite_direction].trim!
    end

    #def self.detach_port port
      #evict_routing_table_references port
      #@@instances -= [port]
      #Needs to support the sid_to_ports
    #end

    def self.detach_all
      @@instances.each do |port|
        evict_routing_table_references port
      end
      @@instances = []
      @@sid_to_ports = {}
    end

    #Routing###########################################################
    #Holds routing table which maps from
    @@routing_table = {
      :request => {},
      :response => {},
    }

    #Maps a sid into one request port and potentionally many response ports
    #via [request, Set<response0, response1...>]
    @@sid_to_ports = {}

    #This returns the *response* (destination) ports for a request originating on the
    #request side.  I.e. it returns a response port.
    def self.response_ports_for_request(action:)
      action = action.to_s
      @@routing_table[:request][action] || []
    end

    def self.response_port_for_request(action:)
      return self.response_ports_for_request(action: action).first
    end

    def self.request_port_for_response(sid:)
      return (@@sid_to_ports[sid] || [])[0]
    end

    def self.signal(port:, name:, info:)
      case name
      when :hangup
        sid = info[:sid]
        if ports = @@sid_to_ports[sid]
          #Get request port (0)
          req_port = ports[0]

          #The request side hungup
          set = ports[1]
          if req_port == port
            set.each do |p|
              p.handle_signal :hangup_notice, {:sid => sid}
            end
            @@sid_to_ports.delete sid
          else
            #Remove ourselves (response) from response set
            set.delete(port)

            #Signal request of termination
            if set.length == 0
              @@sid_to_ports.delete sid
              req_port.handle_signal :hangup_notice, {:sid => sid}
            end
          end
        end
      end
    end

    def self.forward_message(port:, sid:, action:, payload:)
      if port.direction == :request
        if req_port = response_port_for_request(action: action)
          if ports = @@sid_to_ports[sid]
            ports[1] << req_port
          else
            req_set = Set.new [req_port]
            @@sid_to_ports[sid] = [port, req_set]
          end
          req_port.handle_message sid, action.to_s, payload
        else
          #undeliverable
          port.handle_signal :undeliverable, {sid: sid}
        end
      elsif port.direction == :response
        if res_port = request_port_for_response(sid: sid)
          res_port.handle_message sid, action, payload
        else
          #undeliverable
          port.handle_signal :undeliverable, {sid: sid}
        end
      end
    end
  end
end
