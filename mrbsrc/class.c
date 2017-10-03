#include "mruby.h"
#include "mruby/class.h"

static mrb_value
mrb_mod_singleton_class_p(mrb_state *mrb, mrb_value self)
{
  return mrb_bool_value(mrb_type(self) == MRB_TT_SCLASS);
}

void
mrb_mruby_callbacks_attachable_gem_init(mrb_state *mrb)
{
  struct RClass *mod = mrb->module_class;
  mrb_define_method(mrb, mod, "singleton_class?", mrb_mod_singleton_class_p, MRB_ARGS_NONE());
}

void
mrb_mruby_callbacks_attachable_gem_final(mrb_state *mrb)
{
}