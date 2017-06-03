Module.class_eval do
  def singleton_class?
    # The object id of a module is its pointer address shifted 5 to the left
    # and adding its type id:
    # https://github.com/mruby/mruby/blob/2e8ed9514feb74f4137e5835e74f256d52d6f191/src/etc.c#L108
    #
    # The type id of a singleton class is 0xc
    # https://github.com/mruby/mruby/blob/a0fbc46ccd3e129532b05a9fe4f13f42a3c349b2/include/mruby/value.h#L107

    __id__ & 0x1f == 0xc
  end
end