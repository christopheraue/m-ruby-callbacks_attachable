module CallbacksAttachable
  class Callback
    def initialize(registry, events, opts, instance_scope, callback)
      @registry = registry
      @events = events
      @once = opts.fetch(:once?, false)
      @instance_scope = instance_scope
      @callback = callback
      @cancelled = false
    end

    def call(instance, args)
      cancel if @once
      if @instance_scope
        instance.instance_exec(*args, &@callback)
      else
        @callback.call(*args)
      end
    end

    def on_cancel(&on_cancel)
      @on_cancel = on_cancel
    end

    def cancel
      if @cancelled
        raise Error, 'already cancelled'
      else
        @events.each{ |event| @registry.deregister event, self }
        @on_cancel.call if @on_cancel
        @cancelled = true
      end
    end

    def cancelled?
      @cancelled
    end
  end
end