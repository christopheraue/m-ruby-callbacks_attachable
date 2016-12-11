module CallbacksAttachable
  class AllInstancesCallback
    def initialize(klass, opts = {}, &callback)
      @class = klass
      @skip = opts.fetch(:skip, 0)
      @callback = callback
      @call_counts = {}
    end

    def call(instance, args)
      if instance
        call_for_instance(instance, args)
      else
        ObjectSpace.each_object(@class).all?{ |inst| call_for_instance(inst, args) }
      end
    end

    def call_for_instance(instance, args)
      @call_counts[instance.__id__] = @call_counts[instance.__id__].to_i + 1
      return true if @call_counts[instance.__id__] <= @skip
      false != instance.instance_exec(*args, &@callback)
    end
  end
end