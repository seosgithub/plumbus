module PlumbusFakeDriver

  class ConfigDSL
    def initialize &block
      self.instance_eval(&block)
    end

    def supports_actions *actions
      @supported_actions = actions
    end

    def supported_actions
      return @supported_actions || []
    end
  end
end
