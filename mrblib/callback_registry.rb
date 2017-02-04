module CallbacksAttachable
  class CallbackRegistry
    def initialize(owner)
      @owner = owner
      @callbacks = {}
    end

    def register(event, opts, callback)
      @callbacks[event] ||= {}
      @callbacks[event][Callback.new(self, event, opts, callback)] = true
    end

    def registered?(event)
      @callbacks.key? event
    end

    def trigger(instance, event, args)
      @callbacks[event] and @callbacks[event].keys.each{ |callback| callback.call(instance, args) }
    end

    def deregister(event, callback)
      @callbacks[event].delete(callback)
      @callbacks.delete(event) if @callbacks[event].empty?
    end
  end
end