require "callbacks_attachable/version"

module CallbacksAttachable
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def on(event, skip: 0, &callback)
      count = 0
      all_instances_callbacks[event] ||= []
      all_instances_callbacks[event] << proc do |*args|
        next unless (count += 1) > skip
        instance_exec(*args, &callback)
      end
      all_instances_callbacks[event].last
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
        instance_exec(*args, &callback).tap do |result|
          klass.off(event, registered_callback) if result
        end
      end
    end

    def trigger(event, *args, context: self)
      return true unless all_instances_callbacks[event]

      # dup the callback list so that removing callbacks while iterating does
      # still call all callbacks during map.
      all_instances_callbacks[event].dup.all? do |callback|
        context.instance_exec(*args, &callback) != false
      end
    end

    def off(event, callback)
      if all_instances_callbacks[event]
        all_instances_callbacks[event].delete(callback)
        all_instances_callbacks.delete(event) if all_instances_callbacks[event].empty?
      end
      true
    end

    private

    def all_instances_callbacks
      @all_instances_callbacks ||= {}
    end
  end

  def on(*args, &block)
    if_self(:on, *args, &block)
  end

  def once_on(*args, &block)
    if_self(:until_true_on, *args) do |*trigger_args|
      yield *trigger_args
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

  def if_self(*args, skip: 0, &block)
    instance = self
    count = 0
    self.class.__send__(*args, skip: 0) do |*trigger_args|
      next if instance != self
      next unless (count += 1) > skip
      yield *trigger_args
    end
  end
end
