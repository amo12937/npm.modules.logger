"use strict"

chai = require "chai"
expect = chai.expect
sinon = require "sinon"
sinonChai = require "sinon-chai"
chai.use sinonChai

Logger = require "index"
Base = require "amo.modules.base"

describe "Logger", ->
  it "should be subclass of amo.modules.Base", ->
    expect(Logger.__super__).to.be.equal Base.prototype

  describe "its instance", ->
    logger = null
    reporter = null
    beforeEach ->
      reporter = {}
      logger = Logger.create reporter

    for func in ["log", "debug", "info", "warn", "error"]
      do (f = func) ->
        it "should have [#{f}] property", ->
          expect(logger).to.have.property f

        describe "when called [#{f}] function", ->
          mock = null
          now = null
          beforeEach ->
            reporter[f] = sinon.spy()
            now = Date.now()
            (mock = sinon.mock Date).expects("now").once().returns now

          afterEach ->
            mock.verify()

          it "should call reporter's [#{f}] function", ->
            l = "hoge"
            type = "[#{f.toUpperCase()}]"
            d = (new Date now).toJSON()

            logger[f] l
            expect(reporter[f]).to.have.been.calledWith type, d, "::", l
            expect(reporter[f]).to.have.callCount 1

    for func in ["assert", "clear", "dir", "dirxml", "table", "trace", "count"]
      do (f = func) ->
        it "should have [#{f}] property", ->
          expect(logger).to.have.property f

        describe "when called [#{f}] function", ->
          beforeEach ->
            reporter[f] = sinon.spy()

          it "should call reporter's [#{f}] function", ->
            l = "hoge"
            logger[f] l
            expect(reporter[f]).to.have.been.calledWith l
            expect(reporter[f]).to.have.callCount 1

    for func in [["group"], ["time"], ["profile"], ["groupCollapsed", "groupEnd"]]
      do ([start, end] = func) ->
        end ?= "#{start}End"
        it "should have [#{start}] property", ->
          expect(logger).to.have.property start
        
        describe "when called [#{start}] function", ->
          ret = {}
          name = "hoge"
          stub = null
          beforeEach ->
            stub = sinon.stub().returns ret
            reporter[start] = sinon.spy()
            reporter[end] = sinon.spy()

          it "should call reporter's [#{start}] function", ->
            logger[start] name, stub
            expect(reporter[start]).to.have.been.calledWith name
            expect(reporter[start]).to.have.callCount 1

          it "should call reporter's [#{end}] function", ->
            logger[start] name, stub
            expect(reporter[end]).to.have.been.calledWith name
            expect(reporter[end]).to.have.callCount 1

          it "should call a secon argument", ->
            actual = logger[start] name, stub
            expect(stub).to.have.been.call
            expect(stub).to.have.callCount 1
            expect(actual).to.be.equal ret

          it "should call functions in order", ->
            counter = do (c = 0) -> (n) -> ->
              expect(c++).to.be.equal n

            reporter[start] = counter 0
            block           = counter 1
            reporter[end]   = counter 2

            logger[start] name, block
            counter(3)()
            




         



