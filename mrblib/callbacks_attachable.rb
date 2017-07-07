module CallbacksAttachable
  module RegistryOwnable
    def extended(object)
      CallbacksAttachable.extended object
    end

    def included(klass)
      CallbacksAttachable.included klass
    end

    def on(event, *more_events_and_opts, &callback)
      __callbacks__.register(event, *more_events_and_opts, callback)
    end

    def once_on(event, *more_events_and_opts, &callback)
      opts = (more_events_and_opts.last.is_a? Hash) ? more_events_and_opts.pop : {}
      opts[:until] = proc{ true }
      on event, *more_events_and_opts, opts, &callback
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
      if superclass.respond_to? :trigger_for_instance
        superclass.trigger_for_instance(inst, event, args)
      end
      @__callbacks__ and @__callbacks__.trigger(inst, event, args)
      :triggered
    end

    def __callbacks__
      @__callbacks__ ||= CallbackRegistry.new self
    end
  end

  def self.extended(object)
    object.singleton_class.extend RegistryOwnable
  end

  def self.included(klass)
    klass.extend RegistryOwnable
  end

  def on(event, *more_events_and_opts, &callback)
    singleton_class.on event, *more_events_and_opts, &callback
  end

  def once_on(event, *more_events_and_opts, &callback)
    opts = (more_events_and_opts.last.is_a? Hash) ? more_events_and_opts.pop : {}
    opts[:until] = proc{ true }
    on event, *more_events_and_opts, opts, &callback
  end

  def on?(event)
    singleton_class.on? event
  end

  def trigger(event, *args)
    singleton_class.trigger_for_instance(self, event, args)
  end
end
