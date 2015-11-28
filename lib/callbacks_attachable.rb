require "callbacks_attachable/version"

module CallbacksAttachable
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def on(event, skip: 0, &callback)
      count = 0
      callbacks[event] ||= []
      callbacks[event] << proc do |*args|
        next unless (count += 1) > skip
        instance_exec(*args, &callback)
      end
      callbacks[event].last
    end

    def once_on(event, *opts, &callback)
      klass = self
      registered_callback = on(event, *opts) do |*args|
        klass.off(event, registered_callback)
        instance_exec(*args, &callback)
      end
    end

    def until_true_on(event, *opts, &callback)
      klass = self
      registered_callback = on(event, *opts) do |*args|
        klass.off(event, registered_callback) if instance_exec(*args, &callback)
      end
    end

    def trigger(event, *args, context: self)
      return true unless callbacks[event]

      # dup the callback list so that removing callbacks while iterating does
      # still call all callbacks during map.
      callbacks[event].dup.all? do |callback|
        context.instance_exec(*args, &callback) != false
      end
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

  def on(*args, &block)
    if_self(:on, *args, &block)
  end

  def once_on(*args, &block)
    if_self(:until_true_on, *args) do |*args|
      block.call(*args)
      true
    end
  end

  def until_true_on(*args, &block)
    if_self(:until_true_on, *args, &block)
  end

  def trigger(event, *args)
    self.class.trigger(event, *args, context: self)
  end

  def off(*args)
    self.class.off(*args)
  end

  private

  def if_self(*args, &block)
    instance = self
    self.class.__send__(*args) do |*args|
      next false if instance != self
      block.call(*args)
    end
  end
end
