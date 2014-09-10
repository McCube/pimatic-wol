# #Plugin wake on lan
module.exports = (env) ->

  # ###require modules included in pimatic
  # To require modules that are included in pimatic use `env.require`. For available packages take 
  # a look at the dependencies section in pimatics package.json

  Promise = env.require 'bluebird'

  # Require the [cassert library](https://github.com/rhoot/cassert).
  assert = env.require 'cassert'

  # Require the [wake on LAN utilities for node.js](https://github.com/agnat/node_wake_on_lan
  wol = env.require 'wake_on_lan'

  # ###wolPlugin class
  # Create a class that extends the Plugin class and implements the following functions:
  class wolPlugin extends env.plugins.Plugin

    # ####init()
    # The `init` function is called by the framework to ask your plugin to initialise.
    #  
    # #####params:
    #  * `app` is the [express] instance the framework is using.
    #  * `framework` the framework itself
    #  * `config` the properties the user specified as config for your plugin in the `plugins` 
    #     section of the config.json file 
    #     
    # 
    init: (app, @framework, @config) =>

      deviceConfigDef = require("./device-config-schema")

      @framework.deviceManager.registerDeviceClass("WolDevice",{
        configDef: deviceConfigDef.WolDevice,
        createCallback: (config) => new WolDevice(config)
      })

  plugin = new wolPlugin

  class WolDevice extends env.devices.PowerSwitch
    _state: null
    
    actions:
      turnOn:
        description: "send wol"
      turnOff:
        description: "send shutdown"

    attributes:
      state:
        description: "current state of the devise"
        type: "string"

    constructor: (@config) ->
      @name = @config.name
      @id = @config.id
      @repeats = @config.repeats

      super()
    
    getState: () ->
      return Promise.resolve @_state

    changeStateTo: (state) ->
      assert state is on or state is off
      @_state = state      
      
    turnOn: ->
      @changeStateTo on
      env.logger.debug "test"
      wol.wake(@config.mac) while @repeats -= 1
      
    turnOff: ->
      @changeStateTo off
      
    # ...

  plugin.WolDevice = WolDevice

  return plugin
