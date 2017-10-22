module CallbacksAttachable
  module RegistryOwnable
    def extended(object)
      CallbacksAttachable.extended object
    end

    def included(klass)
      CallbacksAttachable.included klass
    end

    def on(*events, &callback)
      __callbacks__.register(*events, @on_opts ? @on_opts : {}, callback)
    end

    def once_on(*events, &callback)
      @on_opts = {once?: true}
      on *events, &callback
    ensure
      @on_opts = nil
    end

    def on?(event)
      @__callbacks__ ? (@__callbacks__.registered? event) : false
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

  def on(*events, &callback)
    singleton_class.on *events, &callback
  end

  def once_on(*events, &callback)
    singleton_class.instance_variable_set :@on_opts, {once?: true}
    on *events, &callback
  ensure
    singleton_class.remove_instance_variable :@on_opts
  end

  def on?(event)
    singleton_class.on? event
  end

  def trigger(event, *args)
    singleton_class.trigger_for_instance(self, event, args)
  end
end
