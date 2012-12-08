class Chainable
  constructor: ->
    @__queue = []
    @__result = null

  __add: (fn, args) ->
    @__queue.push [fn, args]

  end: (callback) ->
    result = null

    iterate = =>
      if @__queue.length == 0
        # return with last result
        callback.apply @, [null].concat result
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
          if err?
            callback err
          else
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
      fn.apply @, args
    else
      # Queue up method
      @__add fn, args
      @

module.exports =
  Chainable: Chainable
  chainable: chainable
