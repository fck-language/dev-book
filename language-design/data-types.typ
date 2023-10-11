== Data Types

This section contains the design for data types:
- Structs
- Enums
- Constant
- Type aliases

=== Structs

```fck
struct StructName {
	properties {
		prop_type a
		prob_type b
	}

	fn add(*self) -> prop_type { a + b }
}
```

Structs are defined using the `struct` keyword, optionally prefixed with either `pub` or `pri` to change the visibility.

=== Enums

```fck
enum EnumName {
	variants {
		Variant1 {
			int field1
			float field2
		}
		Variant2(int, [int])
	}
}
```

Enums are defined using the `enum` keyword, optionally prefixed with either `pub` or `pri` to change the visibility. Enum variants are either tuple- or struct-type variants:
/ Tuple-type: `Enum::TupleVariant(field1, field2)`
/ Struct-type: `Enum::StructVariant { field1: value1, field2: value2 }`
