module CallbacksAttachable
  class CallbackRegistry
    def initialize(owner)
      @owner = owner
      @callbacks = {}
    end

    def on(event, opts = {}, &callback)
      @callbacks[event] ||= []
      @callbacks[event] << Callback.new(@owner, event, opts, &callback)
      @callbacks[event].last
    end

    def once_on(event, *opts)
      registered_callback = @owner.on(event, *opts) do |*args|
        @owner.off(event, registered_callback)
        yield(*args)
      end
    end

    def until_true_on(event, *opts)
      registered_callback = @owner.on(event, *opts) do |*args|
        yield(*args).tap do |result|
          @owner.off(event, registered_callback) if result
        end
      end
    end

    def triggers_on?(event)
      !!@callbacks[event] && @callbacks[event].any?
    end

    def trigger(instance, event, args)
      return true unless @callbacks[event]

      # dup the callback list so that removing callbacks while iterating does
      # still call all callbacks.
      @callbacks[event].dup.each{ |callback| callback.call(instance, args) }
      true
    end

    def off(event, callback)
      return unless @callbacks[event]
      @callbacks[event].delete(callback)
    end
  end
end