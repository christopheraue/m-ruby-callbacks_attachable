module CallbacksAttachable
  class InstanceCallback
    def initialize(instance, skip: 0, &callback)
      @instance = instance
      @skip = skip
      @callback = callback
      @call_count = 0
    end

    def call(*args, **opts)
      @call_count += 1
      return true if @call_count <= @skip
      @callback.call(*args) != false
    end
  end
end