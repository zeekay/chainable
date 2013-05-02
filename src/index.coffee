{slice} = Array.prototype

class Chainable
  constructor: ->
    @__queue = []

  __add: (fn, args) ->
    @__queue.push [fn, args]

  __end: (callback) ->
    result = null

    iterate = =>
      # pop off next method
      [fn, args] = @__queue.shift()

      # add callback to continue iteration
      args.push =>
        result = slice.call arguments, 0

        # check for error
        if (err = result.shift())?
          return callback err

        if @__queue.length == 0
          callback()
        else
          iterate()

      # call next method
      fn.apply @, args

    iterate()

# makes an async function chainable
chainable = (fn) ->
  ->
    args = slice.call arguments, 0
    if fn.length == args.length
      # Callback exists, don't queue up result.
      if @__queue.length > 0
        # we are in the middle of a chain, end it
        @__end (err) =>
          return args.pop() err if err?
          fn.apply @, args
      else
        # method used outside of a chain
        fn.apply @, args
    else
      # Queue up method
      @__add fn, args
    @

wrapper = (fn) ->
  if @constructor == wrapper
    return new Chainable()

  chainable fn

wrapper:: = Chainable::

wrapper.Chainable = Chainable
wrapper.chainable = chainable

module.exports = wrapper
