module PlumbusFakeDriver
  module PlumbusHandlers
    attr_accessor :supported_actions

    def config &block
      dsl = ConfigDSL.new &block
      @supported_actions = dsl.supported_actions
    end

    #Forward a message to the block for a sid
    def handle_message sid, action, payload
      @_spec_received_messages ||= []
      @_spec_received_messages << {
        :sid => sid,
        :action => action,
        :payload => payload
      }
    end

    #Forward a signal, like disconnection
    def handle_signal name, info
      @_spec_received_signals ||= []
      @_spec_received_signals << {
        :name => name,
        :info => info
      }
    end

    def _spec_expand_and_invalidate_supported_actions name
      @supported_actions << name
      invalidate_supported_actions
    end

    def _spec_emit_message sid, action, payload
      emit_message sid, action, payload
    end

    def _spec_received_messages
      return @_spec_received_messages || []
    end

    def _spec_received_signals
      return @_spec_received_signals || []
    end

  end
end
