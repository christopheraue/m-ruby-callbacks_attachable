module CallbacksAttachable
  class Callback
    def initialize(registry, event, opts = {}, callback)
      @registry = registry
      @event = event
      @call_condition = opts.fetch(:if, false)
      @cancel_condition = opts.fetch(:until, false)
      @callback = callback
    end

    def call(instance, args)
      return if @call_condition and not @call_condition.call instance, *args
      @callback.call(instance, *args)
      cancel if @cancel_condition and @cancel_condition.call instance, *args
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