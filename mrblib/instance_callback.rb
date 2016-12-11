module CallbacksAttachable
  class InstanceCallback
    def initialize(instance, opts = {}, &callback)
      @instance = instance
      @skip = opts.fetch(:skip, 0)
      @callback = callback
      @call_count = 0
    end

    def call(instance, args)
      @call_count += 1
      return true if @call_count <= @skip
      @callback.call(*args) != false
    end
  end
end