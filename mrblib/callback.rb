module CallbacksAttachable
  class Callback
    def initialize(owner, event, opts = {}, &callback)
      @owner = owner
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
      @callback.call(*args, instance)
    end

    def cancel
      @owner.off @event, self
    end
  end
end