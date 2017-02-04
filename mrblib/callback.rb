module CallbacksAttachable
  class Callback
    def initialize(registry, event, opts = {}, callback)
      @registry = registry
      @event = event
      @call_condition = opts.fetch(:if, false)
      @cancel_condition = opts.fetch(:until, false)
      @callback = callback
      @call_count = 0
    end

    def call(instance, args)
      @call_count += 1
      return if @call_condition and @call_condition.call instance, *args
      cancel if @cancel_condition and @cancel_condition.call instance, *args
      @callback.call(instance, *args)
    end

    def on_cancel(&on_cancel)
      @on_cancel = on_cancel
    end

    def cancel
      @registry.deregister @event, self
      @on_cancel.call if @on_cancel
      true
    end
  end
end