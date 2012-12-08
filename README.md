# chainable
Create fluent asynchronous APIs.

## Usage
Extend the `Chainable` class and use the `chainable` combinator to designate asynchronous methods as being chainable.

## Example
```coffeescript
{chainable, Chainable} = require 'chainable'

class Test extends Chainable
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
    .add()
    .end (err, result) ->
      result.should.equal 9
      done()
```
