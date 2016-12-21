module CallbacksAttachable
  def self.included(klass)
    klass.extend ClassMethods
    klass.inherited(klass)
  end

  module ClassMethods
    def inherited(klass)
      klass.instance_eval{ @__callback_registry__ = CallbackRegistry.new(klass, AllInstancesCallback) }
    end

    def on(*args, &block)
      @__callback_registry__.on(*args, &block)
    end
    alias on_event on

    def once_on(*args, &block)
      @__callback_registry__.once_on(*args, &block)
    end
    alias once_on_event once_on

    def until_true_on(*args, &block)
      @__callback_registry__.until_true_on(*args, &block)
    end
    alias until_true_on_event until_true_on

    def off(*args)
      @__callback_registry__.off(*args)
    end
    alias off_event off

    def trigger(event, *args)
      ObjectSpace.each_object(self).all?{ |inst| inst.trigger(event, *args) }
    end
    alias trigger_event trigger
  end

  def on(*args, &block)
    __callback_registry__.on(*args, &block)
  end
  alias on_event on

  def once_on(*args, &block)
    __callback_registry__.once_on(*args, &block)
  end
  alias once_on_event once_on

  def until_true_on(*args, &block)
    __callback_registry__.until_true_on(*args, &block)
  end
  alias until_true_on_event until_true_on

  def off(*args)
    __callback_registry__.off(*args)
  end
  alias off_event off

  def trigger(event, *args)
    inst_triggered = (not @__callback_registry__ or @__callback_registry__.trigger(self, event, args))
    @__class_callback_registry__ ||= self.class.instance_eval{ @__callback_registry__ }
    inst_triggered and @__class_callback_registry__.trigger(self, event, args)
  end
  alias trigger_event trigger

  private def __callback_registry__
    @__callback_registry__ ||= CallbackRegistry.new(self, InstanceCallback)
  end
end
