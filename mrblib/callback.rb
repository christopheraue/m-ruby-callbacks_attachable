module CallbacksAttachable
  class Callback
    def initialize(registry, events, opts, instance_scope, callback)
      @registry = registry
      @events = events
      @call_condition = opts.fetch(:if, false)
      @cancel_condition = opts.fetch(:until, false)
      @instance_scope = instance_scope
      @callback = callback
      @canceled = false
    end

    def call(instance, args)
      return if @call_condition and not @call_condition.call instance, *args
      if @instance_scope
        instance.instance_exec(*args, &@callback)
      else
        @callback.call(*args)
      end
      cancel if @cancel_condition and @cancel_condition.call instance, *args
    end

    def on_cancel(&on_cancel)
      @on_cancel = on_cancel
    end

    def cancel
      if @canceled
        raise Error, 'already canceled'
      else
        @events.each{ |event| @registry.deregister event, self }
        @on_cancel.call if @on_cancel
        @canceled = true
      end
    end

    def canceled?
      @canceled
    end
  end
end