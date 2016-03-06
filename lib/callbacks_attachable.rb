require "callbacks_attachable/version"
require "callbacks_attachable/callback_handler"
require "callbacks_attachable/instance_callback"
require "callbacks_attachable/all_instances_callback"

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

    def trigger(*args)
      __callback_handler__.trigger(*args)
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

  def trigger(*args)
    self.class.trigger(*args, instance: self)
    __callback_handler__.trigger(*args)
  end

  private

  def __callback_handler__
    @__callback_handler__ ||= CallbackHandler.new(self, InstanceCallback)
  end
end
