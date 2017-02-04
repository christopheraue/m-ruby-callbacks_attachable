module CallbacksAttachable
  class Callback
    def initialize(registry, event, opts = {}, callback)
      @registry = registry
      @event = event
      @skip_condition = opts.fetch(:skip, false)
      @cancel_condition = opts.fetch(:until, false)
      @callback = callback
      @call_count = 0
    end

    def call(instance, args)
      @call_count += 1
      return if @skip_condition and @skip_condition.call @call_count
      cancel if @cancel_condition and @cancel_condition.call @call_count
      @callback.call(instance, *args)
    end

    def cancel
      @registry.deregister @event, self
    end
  end
end