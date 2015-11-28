"use strict"

module.exports = class Logger extends require "amo.modules.base"
  constructor: (@_reporter = {}) ->
    super()

Logger.defaultLogger = Logger.create()
    
Logger.logDecolator = (func) ->
  type = "[#{func.toUpperCase()}]"
  return ->
    dt = new Date Date.now()
    @_reporter[func]?(
      type
      dt.toJSON()
      "::"
      arguments...
    )

for func in ["log", "debug", "info", "warn", "error"]
  Logger.prototype[func] = Logger.logDecolator func

Logger.simpleDecolator = (func) -> ->
  @_reporter[func]? arguments...

for func in ["assert", "clear", "dir", "dirxml", "table", "trace", "count"]
  Logger.prototype[func] = Logger.simpleDecolator func

Logger.groupDecolator = (func, funcEnd = "#{func}End") -> (name, block) ->
  @_reporter[func]? name
  result = block()
  @_reporter[funcEnd]? name
  return result

for func in ["group", "time", "profile"]
  Logger.prototype[func] = Logger.groupDecolator func

Logger.prototype.groupCollapsed = Logger.groupDecolator "groupCollapsed", "groupEnd"



