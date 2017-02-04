module CallbacksAttachable
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def on(event, opts = {}, &callback)
      __callback_registry__.register(event, opts, callback)
    end
    alias on_event on

    def trigger(event, *args)
      ObjectSpace.each_object(self).all?{ |inst| inst.trigger(event, *args) }
    end
    alias trigger_event trigger

    def triggers_on?(event)
      __callback_registry__.registered? event
    end

    private def __callback_registry__
      @__callback_registry__ ||= CallbackRegistry.new(self)
    end
  end

  def on(event, opts = {}, &callback)
    __callback_registry__.register(event, opts, callback)
  end
  alias on_event on

  def trigger(event, *args)
    (not @__callback_registry__ or @__callback_registry__.trigger(self, event, args))
    (@__class_callback_registry__ || __class_callback_registry__).trigger(self, event, args)
    true
  end
  alias trigger_event trigger

  def triggers_on?(event)
    __callback_registry__.registered? event
  end

  private def __callback_registry__
    @__callback_registry__ ||= CallbackRegistry.new(self)
  end

  private def __class_callback_registry__
    @__class_callback_registry__ ||= self.class.__send__ :__callback_registry__
  end
end
