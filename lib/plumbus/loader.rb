module Plumbus
  module Loader
    def self.load path
      self.unload_all
      dsl = LoaderDSL.new(path)

      #Load ports
      dsl.ports.each do |_port|
        direction = _port[:direction]
        driver = _port[:driver]
        config_block = _port[:config_block]

        #Load driver if not already loaded
        klass = Driver.load driver

        #Create instance of driver module
        port = Port.new(driver_module_klass: klass, direction: direction)
        port.config &config_block
        port.attach!
      end
    end

    def self.unload_all
      Ports.detach_all
    end
  end

  class LoaderDSL
    attr_reader :ports

    def initialize src_path
      @ports = []
      contents = File.read(src_path)

      instance_eval contents, src_path
    end

    def port direction, driver, &config_block
      raise ArgumentError, "The given direction #{direction.inspect} was not a valid direction. Valid directions include #{Port::SUPPORTED_DIRECTIONS.inspect}" unless Port::SUPPORTED_DIRECTIONS.include? direction
      raise ArgumentError, "No config block was given for the port #{direction.inspect}, #{driver.inspect}" unless config_block
      @ports << {:direction => direction, :driver => driver, :config_block => config_block}
    end
  end
end
