== Visibility

There are three levels of visibility in fck (in order):
1. Private using `pri`
2. Restricted using nothing
3. Public using `pub`

To explain these, we'll go through them one by one in the context of a module, and for a data type (struct or enum).

=== Module level visibility

Consider the following module

```fck
pub const int CONST1 = 1
const float CONST2 = 1
pri const bool CONST3 = false
```

Within the module, all of the constants are visible. Within the project, only `CONST1` and `CONST2` are visible. Outside of the project, where it's used as a dependency, only `CONST1` is visible#footnote[This assumes that `CONST1` is exported from the package.].

One notable case might be the following module example:

```fck
pri mod inner {
	pri const int CONST = 1
}

use inner::*
```

This does not expose `CONST` to the module. You cannot increase the visibility of anything, only decrease it; `pub` can become `pri` but not the other way around.

=== Data types

When defining functions for either a struct or enum the visibility markers mean different things. A `pri` function is only accessible within the struct or enum (not public). A `pub` function is visible everywhere, including outside the project. No visibility marker on a function means it's visible only within the project.

Consider the following module:

```fck
pub struct MyStruct {
	properties {
		int a
		int b
	}

	pub fn new(int a, int b) -> Self {
		return Self { a: a, b: b }
	}

	fn inc_a(*self) {
		self.a++
	}

	pri fn inc_b(*self) {
		self.b++
	}
}
```

Within the module, project, and externally, we can see `MyStruct` and `MyStruct::new`. Externally, we can't see `MyStruct::inc_a`, but we can see this within the project. `MyStruct::inc_b` cannot be seen anywhere. Private functions for structs and enums can only be used internally. If we added a function to `MyStruct` that looked like this:

```fck
fn local_inc_b(*self) {
	self.inc_b()
}
```

this would be okay, and we would be able to use `MyStruct::local_inc_b` from anywhere within the project, but not externally.
