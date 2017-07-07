# CallbacksAttachable

Attach callbacks to classes to be triggered for all instances or attach them
to an individual instance to be triggered only for this instance.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'callbacks_attachable', '~> 2.0'
```

And then execute:

    $ bundle

Or install it yourself:

    $ gem install callbacks_attachable

## Usage

```ruby
require 'callbacks_attachable'

class AClass
    include CallbacksAttachable
end
```

### Callbacks attached to the class

Attach callbacks for an event for all instances of a class with:

```ruby
callback = AClass.on(:event) do |method|
  puts __send__(method)
end

instance0 = AClass.new(value: 0)
instance1 = AClass.new(value: 1)

AClass.trigger(:event, :value) # => 0
                               #    1
```

Callbacks attached to a class are evaluated in the context of the instance they
are triggered for with `#instance_exec`. This means `self` inside the callback
is the instance the callback is evaluated for. The arguments given to
`.trigger` are passed to the callback as additional arguments.

Registering a callback returns a `Callback` object. To cancel the callback use
`#cancel` on that object.

```ruby
callback = AClass.on(:event) { do_something }
callback.cancel
```

A callback can also be registered for multiple events:

```ruby
AClass.on(:event1, :event2, :event3, opts, &callback) 
```

If you want to execute a callback just a single time attach it with `.once_on`:

```ruby
AClass.once_on(:singular) { puts 'callback called!' }
AClass.trigger(:singular) # => puts 'callback called!' and immediately
                          #    detaches the callback
AClass.trigger(:singular) # => does nothing
```

To filter the instances to call the callback for, use the `:if` option:

```ruby
instance0 = AClass.new(value: 0)
instance1 = AClass.new(value: 1)
instance2 = AClass.new(value: 2)
AClass.on(:even, if: proc{ |inst| inst.value.even? }) do |instance|
    puts instance.value
end

AClass.trigger(:even) # => 0
                      #    2
```

This is especially useful in combination with `.once_on` to execute the
callback just for the first instance meeting certain criteria.

### Callbacks attached to an instance

All above mentioned methods on the class level also exist for each instance of
the class. With one exception: Callbacks are executed bound to the context its
block was defined, just like normal blocks are. `self` inside a callback is the
same as outside of it.

Callbacks for an individual instance are executed by calling `#trigger` on it.
This also executes callbacks attached to the class.

```ruby
instance = AClass.new

AClass.on(:event) { puts 'class callback' }
instance.on(:event) { puts 'instance callback' }

instance.trigger(:event) # => 'class callback'
                         #    'instance callback'
```