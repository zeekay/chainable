chai = require 'chai'
assert = chai.assert
should = chai.should()

chainable = require '../'

class Test extends chainable
  numbers: []

  number: chainable (number, callback) ->
    @numbers.push number
    callback null

  add: chainable (callback) ->
    result = 0
    while n = @numbers.pop()
      result += n

    callback null, result

  wait: chainable (callback) ->
    setTimeout =>
      callback null
    , 100

describe 'chainable', ->
  it 'should allow chainable asynchronous method calls', (done) ->
    test = new Test()
    test.number(4)
        .number(5)
        .wait()
        .add (err, result) ->
          result.should.equal 9
          done()
