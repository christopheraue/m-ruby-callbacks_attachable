module CallbacksAttachable
  class CallbackRegistry
    def initialize(owner_class)
      @singleton_owner = owner_class.singleton_class?
      @callbacks = {}
    end

    def register(*events, opts, callback)
      unless opts.is_a? Hash
        events << opts
        opts = {}
      end
      callback = Callback.new(self, events, opts, !@singleton_owner, callback)
      events.each do |event|
        @callbacks[event] ||= {}
        @callbacks[event][callback] = true
      end
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