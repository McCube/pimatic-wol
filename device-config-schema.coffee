module.exports = {
  title: "pimatic-wol device config schemas"
  WolDevice: {
    title: "WolDevice config options"
    type: "object"
    properties:
      mac:
        description: "the mac adress of the device"
        type: "string"
        default: ""
      repeats:
        descriptions: "repeats of sending the wol command"
        type: "number"
        default: 2
  }
}
