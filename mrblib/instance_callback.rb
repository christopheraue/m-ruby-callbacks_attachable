module CallbacksAttachable
  class InstanceCallback
    def initialize(instance, event, opts = {}, &callback)
      @instance = instance
      @event = event
      @skip = opts.fetch(:skip, 0)
      @callback = callback
      @call_count = 0
    end

    def call(instance, args)
      @call_count += 1
      return true if @call_count <= @skip
      @callback.call(*args)
    end

    def cancel
      @instance.off @event, self
    end
  end
end