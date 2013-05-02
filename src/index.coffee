class Chainable
  constructor: ->
    @__queue = []

  __add: (fn, args) ->
    @__queue.push [fn, args]

  __end: (callback) ->
    err = null
    result = null

    done = =>
      # return with last result
      callback.apply @, [err].concat result

    iterate = =>
      if @__queue.length == 0
        done()
      else
        # pop off next method to execute
        [fn, args] = @__queue.shift()

        # pass along result of previous method call
        if result?
          args = args.concat result
          result = null

        # add callback to continue iteration
        args.push ->
          _args = Array.prototype.slice.call arguments

          # check for error
          err = _args.shift()
          return done() if err?

          # store result and continue iteration
          result = _args
          iterate()

        fn.apply @, args

    iterate()

# makes an async function chainable
chainable = (fn) ->
  ->
    args = Array.prototype.slice.call arguments
    if typeof args[args.length-1] == 'function'
      # Callback exists, don't queue up result.
      if @__queue.length > 0
        # we are in the middle of a chain, end it
        @__end =>
          _args = Array.prototype.slice.call arguments
          fn.apply @, args.concat _args
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
