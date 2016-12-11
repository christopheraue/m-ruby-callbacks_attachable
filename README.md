# CallbacksAttachable

Attach callbacks to a class and trigger them for all its instances or just one
particular instance. Additionally, instances can also have their own set of
individual callbacks.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'callbacks_attachable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install callbacks_attachable

## Usage

```ruby
require 'callbacks_attachable'

class AClass
    include CallbacksAttachable
end
```

### Callbacks attached to the class

Attach callbacks for an event to the class with:

```ruby
callback = AClass.on(:event) do |method|
    puts self.__send__(method)
end
```

Callbacks attached to a class are executed in the context of each existing
instance. To trigger all `:event` callbacks for all instances of `AClass`, use:

```ruby
AClass.trigger(:event, :name) # => puts 'AClass'
```

The second and other arguments given to `.trigger` are passed to the callback.

Callbacks attached to a class can also be triggered for just one of its
instances with `.trigger_for`:

```ruby
an_instance = AClass.new
AClass.trigger_for(an_instance, :event, :__id__)
# => puts the result of an_instance.__id__
```

To detach a callback call `.off` with the event's name and the callback handle
returned by `.on`:

```ruby
callback = AClass.on(:event) { do_something }
AClass.off(:event, callback)
```

If you want to execute a callback just a single time attach it with `.once_on`:

```ruby
AClass.once_on(:singularity) { puts 'callback called!' }
AClass.trigger(:singularity) # => puts 'callback called!' and immediately
                                      #    detaches the callback
AClass.trigger(:singularity) # => does nothing
```

To detach a callback when a condition is met use `.until_true_on`. The callback
will be detached if it has a truthy (!) return value.

```ruby
counter = 0
AClass.until_true_on(:count_to_two) do
    puts counter
    counter >= 2
end

AClass.trigger(:count_to_two) # => puts 0
AClass.trigger(:count_to_two) # => puts 1
AClass.trigger(:count_to_two) # => puts 2 and detaches the callback
AClass.trigger(:count_to_two) # => does nothing
```

### Callbacks attached to an instance

All above mentioned methods on the class level also exist for each instance of
the class. Callbacks for an individual instance are executed by calling
`#trigger` on it. They are also called, when calling `.trigger` or
`.trigger_for(instance, ...)` on the its class.

Callbacks attached to individual instances are evaluated in their lexical scope.
So, `self` inside and outside the callback is the same object.

```ruby
callbacks_holder1 = AClass.new
callbacks_holder2 = AClass.new

callback1 = callbacks_holder1.on(:event) { puts 'This is #1!' }
callback2 = callbacks_holder2.on(:event) { puts 'This is #2!' }

callbacks_holder1.trigger(:event) # => puts 'This is #1!'
callbacks_holder2.trigger(:event) # => puts 'This is #2!'

AClass.trigger(:event) # => puts 'This is #1!' and 'This is #2!'

callbacks_holder1.off(:event, callback)
callbacks_holder2.off(:event, callback)
```

The two methods `#once_on` and `#until_true_on` are available for instances,
too. They work as you'd expect.