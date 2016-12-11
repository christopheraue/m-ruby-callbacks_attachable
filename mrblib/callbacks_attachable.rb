module CallbacksAttachable
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def on(*args, &block)
      __callback_handler__.on(*args, &block)
    end

    def once_on(*args, &block)
      __callback_handler__.once_on(*args, &block)
    end

    def until_true_on(*args, &block)
      __callback_handler__.until_true_on(*args, &block)
    end

    def off(*args)
      __callback_handler__.off(*args)
    end

    def trigger(event, *args)
      __callback_handler__.trigger(nil, event, args)
    end

    def trigger_for(instance, event, *args)
      __callback_handler__.trigger(instance, event, args)
    end

    private

    def __callback_handler__
      @__callback_handler__ ||= CallbackHandler.new(self, AllInstancesCallback)
    end
  end

  def on(*args, &block)
    __callback_handler__.on(*args, &block)
  end

  def once_on(*args, &block)
    __callback_handler__.once_on(*args, &block)
  end

  def until_true_on(*args, &block)
    __callback_handler__.until_true_on(*args, &block)
  end

  def off(*args)
    __callback_handler__.off(*args)
  end

  def trigger(event, *args)
    self.class.trigger_for(self, event, *args) and __callback_handler__.trigger(self, event, args)
  end

  private

  def __callback_handler__
    @__callback_handler__ ||= CallbackHandler.new(self, InstanceCallback)
  end
end
