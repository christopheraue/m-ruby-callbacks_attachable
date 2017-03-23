module CallbacksAttachable
  module RegistryOwnable
    def extended(object)
      object.singleton_class.extend RegistryOwnable
    end

    def on(event, opts = {}, &callback)
      (@__callbacks__ ||= CallbackRegistry.new self).register(event, opts, callback)
    end

    def once_on(event, opts = {}, &callback)
      on(event, opts.merge(until: proc{ true }), &callback)
    end

    def on?(event)
      @__callbacks__ ? (@__callbacks__.registered? event) : false
    end

    def trigger(event, *args)
      ObjectSpace.each_object(self).each do |inst|
        trigger_for_instance(inst, event, args)
      end
    end

    def trigger_for_instance(inst, event, args)
      @__callbacks__ and @__callbacks__.trigger(inst, event, args)
      :triggered
    end
  end

  def self.extended(object)
    object.singleton_class.extend RegistryOwnable
  end

  def self.included(klass)
    klass.extend RegistryOwnable
  end

  def on(*args, &callback)
    singleton_class.on *args, &callback
  end

  def once_on(*args, &callback)
    singleton_class.once_on *args, &callback
  end

  def on?(event)
    singleton_class.on? event
  end

  def trigger(event, *args)
    singleton_class.trigger_for_instance(self, event, args)
  end
end
