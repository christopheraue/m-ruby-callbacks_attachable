module CallbacksAttachable
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def on(event, opts = {}, &block)
      __callback_registry__.on(event, opts, &block)
    end
    alias on_event on

    def off(*args)
      __callback_registry__.off(*args)
    end
    alias off_event off

    def trigger(event, *args)
      ObjectSpace.each_object(self).all?{ |inst| inst.trigger(event, *args) }
    end
    alias trigger_event trigger

    def triggers_on?(event)
      __callback_registry__.triggers_on? event
    end

    private def __callback_registry__
      @__callback_registry__ ||= CallbackRegistry.new(self)
    end
  end

  def on(event, opts = {}, &block)
    __callback_registry__.on(event, opts, &block)
  end
  alias on_event on

  def off(*args)
    __callback_registry__.off(*args)
  end
  alias off_event off

  def trigger(event, *args)
    instance_triggered = (not @__callback_registry__ or @__callback_registry__.trigger(self, event, args))
    class_triggered = (@__class_callback_registry__ || __class_callback_registry__).trigger(self, event, args)
    instance_triggered and class_triggered
  end
  alias trigger_event trigger

  def triggers_on?(event)
    __callback_registry__.triggers_on? event
  end

  private def __callback_registry__
    @__callback_registry__ ||= CallbackRegistry.new(self)
  end

  private def __class_callback_registry__
    @__class_callback_registry__ ||= self.class.__send__ :__callback_registry__
  end
end
