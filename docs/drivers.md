#Drivers

##Why do we need drivers?
*Drivers* are the sole provider of [Plumbus'](https://github.com/sotownsend/plumbus) input and output capabilities.

##How do drivers get loaded?
Driver's are designed to be *plugged into* [Plumbus](https://github.com/sotownsend/plumbus)  through a **user-defined** configuration file which will declare a `port` with a driver name. e.g.

```rb
port(:request, 'plumbus_http') do
  #Driver specific config
end
```

In the example, the port function will ensure the *driver* is loaded in the runtime by calling `require plumbus_http`. As long as the *driver* is a *gem*, this should work.

Then the driver's module named `DriverName::PlumbusHandlers` is loaded into a `Plumbus::Port` object.

##Driver API
The requirements for a driver is that (1) it is a gem, and (2) contains a module named `DriverName::PlumbusHandlers`. The module should provide several methods:

```rb
  def config &block
  end
  
  def handle_message sid, action, payload
  end
  
  def handle_signal name, info
  end
  
  #Should return [String] of available actions
  def supported_actions
  end
```

Inside any of these methods, a driver has access to the following methods:

  * `invalidate_supported_actions()`
  * `emit_message(sid, action, payload)`
  * `raise_signal(name, info)`