#import "@preview/minitoc:0.1.0": minitoc

== Primitives <lang_design-primitives>

#minitoc(target: heading.where(level: 3))

There are 10 primitives in fck. Each will be explained below.

=== Integers

There are four integer primitives:
/ `int`: Signed integer. Is as many bits as a memory reference; so on a 32-bit platform this will be 32 bits long, and 64 bits long on a 64-bit platform
/ `uint`: Unsigned version of `int`
/ `dint`: Dynamically sized signed integer
/ `udint`: Unsigned version of `dint`

=== Floats

There are two types of float:
/ `float`: Floating point number with the same number of bits as an `int` type. Specifically, it's either "binary32" or "binary64" from #link("https://ieeexplore.ieee.org/document/8766229")[IEEE 754-2019].
/ `bfloat`: Floating point value stored in base 10. See below for more information

`bfloat` uses two `int` values. The first `int` value represents the value if you removed the decimal point ("mantissa"); with the second `int` representing the base 10 exponent of the value ("exponent"). See @bfloat-examples for examples.

#[
#set raw(lang: none)
#figure(table(
	columns: (auto,) * 3, align: left,
	[*Value*], [*Mantissa*], [*Exponent*],
	[`25.038`], [`25038`], [`+1`],
	[`0.00196`], [`196`], [`-3`],
	[`-120.4`], [`-124`], [`+2`],
), caption: [Constituent parts of `bfloat` example values])<bfloat-examples>
]

=== Strings

There is only one type of string in fck (`str`); it's dynamically sized. There is also a `char` type for singular characters which is formally a #link("https://www.unicode.org/glossary/#unicode_scalar_value")["Unicode Scalar Value"].

Internally, a `str` type is just a `[char]` type.

=== Lists

Lists are dynamically sized arrays of the same type of value and use the notation `List<T>` or `[T]`.

Lists can also have a static size using the notation `StaticList<T, N>` or `[T; N]` where `N` is the length of the list.

=== Booleans

The `bool` type represents a single boolean value. This, internally, takes up 1 byte.
