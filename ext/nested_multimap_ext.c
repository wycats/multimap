#include "ruby.h"

static VALUE rb_nested_multimap_aref(int argc, VALUE *argv, VALUE self)
{
	int i;
	VALUE r;

	for (i = 0, r = self; TYPE(r) != T_ARRAY; i++)
		r = rb_hash_aref(r, (i < argc) ? argv[i] : Qnil);

	return r;
}

void Init_nested_multimap_ext() {
	VALUE cNestedMultiMap = rb_const_get(rb_cObject, rb_intern("NestedMultiMap"));
	rb_define_method(cNestedMultiMap, "[]", rb_nested_multimap_aref, -1);
}
