#include "ruby.h"

static VALUE rb_nested_multimap_aref(int argc, VALUE *argv, VALUE self)
{
	int i;
	VALUE r;

	for (i = 0, r = self; TYPE(r) != T_ARRAY; i++)
		r = rb_hash_aref(r, (i < argc) ? argv[i] : Qnil);

	return r;
}

VALUE cNestedMultiMapExt;

void Init_nested_multimap_ext() {
	cNestedMultiMapExt = rb_define_module("NestedMultiMapExt");
	rb_define_method(cNestedMultiMapExt, "cfetch", rb_nested_multimap_aref, -1);
}
