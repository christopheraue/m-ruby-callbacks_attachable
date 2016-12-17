module CallbacksAttachable
  class CallbackRegistry
    def initialize(object, callback_class)
      @object = object
      @callback_class = callback_class
      @callbacks = {}
    end

    def on(event, opts = {}, &callback)
      @callbacks[event] ||= []
      @callbacks[event] << @callback_class.new(@object, opts, &callback)
      @callbacks[event].last
    end

    def once_on(event, *opts, &callback)
      callback_registry = self
      registered_callback = @object.on(event, *opts) do |*args|
        callback_registry.off(event, registered_callback)
        yield(*args)
      end
    end

    def until_true_on(event, *opts, &callback)
      callback_registry = self
      registered_callback = @object.on(event, *opts) do |*args|
        yield(*args).tap do |result|
          callback_registry.off(event, registered_callback) if result
        end
      end
    end

    def trigger(instance, event, args)
      return true unless @callbacks[event]

      # dup the callback list so that removing callbacks while iterating does
      # still call all callbacks during map.
      @callbacks[event].dup.all?{ |callback| callback.call(instance, args) }
    end

    def off(event, callback)
      return unless @callbacks[event]
      @callbacks[event].delete(callback)
    end
  end
end