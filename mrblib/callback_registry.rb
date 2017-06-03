module CallbacksAttachable
  class CallbackRegistry
    def initialize(owner_class)
      @singleton_owner = owner_class.singleton_class?
      @callbacks = {}
    end

    def register(event, opts, callback)
      @callbacks[event] ||= {}
      callback = Callback.new(self, event, opts, !@singleton_owner, callback)
      @callbacks[event][callback] = true
      callback
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