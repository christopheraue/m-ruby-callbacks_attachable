module CallbacksAttachable
  module RegistryOwnable
    def on(event, opts = {}, &callback)
      __callbacks__.register(event, opts, callback)
    end

    def triggers_on?(event)
      __callbacks__.registered? event
    end

    private def __callbacks__
      @__callbacks__ ||= CallbackRegistry.new(self)
    end
  end

  include RegistryOwnable

  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    include RegistryOwnable

    def trigger(event, *args)
      ObjectSpace.each_object(self).all?{ |inst| inst.trigger(event, *args) }
    end
  end

  def trigger(event, *args)
    @__callbacks__ and @__callbacks__.trigger(self, event, args)
    @class_callbacks ||= self.class.__send__ :__callbacks__
    @class_callbacks.trigger(self, event, args)
    true
  end
end
