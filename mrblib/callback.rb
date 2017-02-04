module CallbacksAttachable
  class Callback
    def initialize(owner, event, opts = {}, &callback)
      @owner = owner
      @event = event
      @skip = opts.fetch(:skip, 0)
      @callback = callback
      @call_count = 0
    end

    def call(instance, args)
      @call_count += 1
      return true if @call_count <= @skip
      @callback.call(*args, instance)
    end

    def cancel
      @owner.off @event, self
    end
  end
end