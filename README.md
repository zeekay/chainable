# chainable [![Build Status](https://travis-ci.org/zeekay/chainable.svg?branch=master)](https://travis-ci.org/zeekay/chainable)

[![Greenkeeper badge](https://badges.greenkeeper.io/zeekay/chainable.svg)](https://greenkeeper.io/)
Create fluent asynchronous APIs.

## Usage
Extend the `Chainable` class and use the `chainable` combinator to designate
asynchronous methods as being chainable.  Methods wrapped with the `chainable`
combinator will be treated as chainable when they are not passed a callback.
Each method in the chain will be executed in series, passing it's result to the
next method. Pass a callback to the final method to end the chain and begin
computation.

## Example
```coffeescript
chainable = require 'chainable'

class Calculator extends chainable
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
    setTimeout ->
      callback null
    , 100

test = new Test()
test.number(4)
    .number(5)
    .wait()
    .add (err, result) ->
        # result == 9
