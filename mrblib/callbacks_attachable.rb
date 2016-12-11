module CallbacksAttachable
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def on(*args, &block)
      __callback_registry__.on(*args, &block)
    end

    def once_on(*args, &block)
      __callback_registry__.once_on(*args, &block)
    end

    def until_true_on(*args, &block)
      __callback_registry__.until_true_on(*args, &block)
    end

    def off(*args)
      __callback_registry__.off(*args)
    end

    def trigger(event, *args)
      ObjectSpace.each_object(self).all?{ |inst| inst.trigger(event, *args) }
    end

    private

    def __callback_registry__
      @__callback_registry__ ||= CallbackRegistry.new(self, AllInstancesCallback)
    end
  end

  def on(*args, &block)
    __callback_registry__.on(*args, &block)
  end

  def once_on(*args, &block)
    __callback_registry__.once_on(*args, &block)
  end

  def until_true_on(*args, &block)
    __callback_registry__.until_true_on(*args, &block)
  end

  def off(*args)
    __callback_registry__.off(*args)
  end

  def trigger(event, *args)
    self.class.__send__(:__callback_registry__).trigger(self, event, args) and __callback_registry__.trigger(self, event, args)
  end

  private

  def __callback_registry__
    @__callback_registry__ ||= CallbackRegistry.new(self, InstanceCallback)
  end
end
