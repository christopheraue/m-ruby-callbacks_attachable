require "callbacks_attachable/version"

module CallbacksAttachable
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def on(event, &callback)
      callbacks[event] ||= []
      callbacks[event] << callback
      callback
    end

    def once_on(event, &callback)
      klass = self
      callback = on(event) do |*args|
        klass.off(event, callback)
        instance_exec(*args, &callback)
      end
    end

    def until_true_on(event, &callback)
      klass = self
      callback = on(event) do |*args|
        klass.off(event, callback) if instance_exec(*args, &callback)
      end
    end

    def trigger(event, *args, context: self)
      return true unless callbacks[event]

      # dup the callback list so that removing callbacks while iterating does
      # still call all callbacks during map.
      callbacks[event].dup.map do |callback|
        context.instance_exec(*args, &callback)
      end.all?
    end

    def off(event, callback)
      if callbacks[event]
        callbacks[event].delete(callback)
        callbacks.delete(event) if callbacks[event].empty?
      end
      true
    end

    private

    def callbacks
      @callbacks ||= {}
    end
  end

  def on(event, &block)
    if_self(:on, event, &block)
  end

  def once_on(event, &block)
    if_self(:until_true_on, event) do |*args|
      block.call(*args)
      true
    end
  end

  def until_true_on(event, &block)
    if_self(:until_true_on, event, &block)
  end

  def trigger(event, *args)
    self.class.trigger(event, *args, context: self)
  end

  def off(event, callback)
    self.class.off(event, callback)
  end

  private

  def if_self(method, event, &block)
    instance = self
    self.class.__send__(method, event) do |*args|
      next false if instance != self
      block.call(*args)
    end
  end
end
