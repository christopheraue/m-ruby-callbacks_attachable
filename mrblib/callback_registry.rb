module CallbacksAttachable
  class CallbackRegistry
    def initialize(object, callback_class)
      @object = object
      @callback_class = callback_class
    end

    def on(event, opts = {}, &callback)
      __callbacks__[event] ||= []
      __callbacks__[event] << @callback_class.new(@object, opts, &callback)
      __callbacks__[event].last
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
      return true if __callbacks__[event].nil?

      # dup the callback list so that removing callbacks while iterating does
      # still call all callbacks during map.
      __callbacks__[event].dup.all?{ |callback| callback.call(instance, args) }
    end

    def off(event, callback)
      return unless __callbacks__[event]
      __callbacks__[event].delete(callback)
    end

    private

    def __callbacks__
      @__callbacks__ ||= {}
    end
  end
end