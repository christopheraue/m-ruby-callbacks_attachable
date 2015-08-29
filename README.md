# CallbacksAttachable

Attach callbacks to every ruby object including this mixin. Trigger all
callbacks attached under the same namespace and detach callback when you no
longer need them.

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

class CallbacksHolder
    include CallbackAttachable
end
```

### Callbacks attached to the class

Attach callbacks to the class:

```ruby
callback = CallbacksHolder.on(:event) do |method|
    puts self.__send__(method)
end
```

Callbacks attached to the class are executed in the context of it, i.e. `self`
points to the class.

Trigger all `:event` callbacks with:

```ruby
CallbacksHolder.trigger(:event, :name) # => puts 'CallbacksHolder'
```

The second and further arguments given to `.trigger` are passed down to the
callback.

Callbacks can be executed in the context of a different context by passing the
`context` option to `.trigger`:

```ruby
object = Object.new
CallbacksHolder.trigger(:event, :__id__, context: object) # => puts the result of object.__id__
```

To detach a callback call `.off` with the event namespace and the callback
handle returned by `.on`:

```ruby
CallbacksHolder.off(:event, callback)
CallbacksHolder.trigger(:event, :name)  # => nothing will happen
```

If you want to execute a callback just a single time attach it with `.once_on`:

```ruby
CallbacksHolder.once_on(:singularity) { puts 'callback called!' }
CallbacksHolder.trigger(:singularity) # => puts 'callback called!' and immediately
                                      #    detaches the callback
CallbacksHolder.trigger(:singularity) # => does nothing
```

To detach a callback when a condition is met use `.until_true_on`. The callback
will be detached if it has a truthy (!) return value.

```ruby
counter = 0
CallbacksHolder.until_true_on(:count_to_two) do
    puts counter
    counter >= 2
end

CallbacksHolder.trigger(:count_to_two) # => puts 0
CallbacksHolder.trigger(:count_to_two) # => puts 1
CallbacksHolder.trigger(:count_to_two) # => puts 2 and detaches the callback
CallbacksHolder.trigger(:count_to_two) # => does nothing
```

### Callbacks attached to an instance

All above mentioned methods on the class level also exist for each instance of
the class. Callbacks are executed if the instance they are attached to or their
class calls `#trigger`.

Callbacks are called in their lexical scope. So, `self` inside and outside
the callback is the same object. The context of a callback cannot be changed
with the `context` option of the `#trigger` method as it is possible for
class callbacks.

```ruby
callbacks_holder1 = CallbacksHolder.new
callbacks_holder2 = CallbacksHolder.new

callback1 = callbacks_holder1.on(:event) { puts 'This is #1!' }
callback2 = callbacks_holder2.on(:event) { puts 'This is #2!' }

callbacks_holder1.trigger(:event) # => puts 'This is #1!'
callbacks_holder2.trigger(:event) # => puts 'This is #2!'

CallbacksHolder.trigger(:event) # => puts 'This is #1!' and 'This is #2!'

callbacks_holder1.off(:event, callback)
callbacks_holder2.off(:event, callback)
```

The two methods `#once_on` and `#until_true_on` are available for instances,
too, and work as you'd expect.