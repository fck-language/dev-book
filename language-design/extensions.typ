== Extensions

Extensions are groups of functions that can be applied to any data type. We use the notation (in this book and in code) `A: B` to indicate that data type `A` is extended by extension `B`; for example, `int: Add<Self>`.

```
extend DataType with Extension {
	/* ... */
}
```

Some useful extensions are:
- ```
  /// Convert one value into another using the `as` keyword
  extension Into<T> {
    /// Convert the value after cloning it
  	fn into(self) -> T
  }
  ```
  You can pair this with `extend *DataType with Into<T> { /* ... */ }` to prevent implicit cloning before converting one value into another
- ```
  /// Format `self` into a string. Used when printing the value or when putting it in an f-string
  extension Format {
    /// Format `self` using the provided formatter to return a string
    /// @param(formatter) Requested format to provide
  	fn fmt(*self, Formatter formatter) -> str
  }
  ```

=== Extension function visibility

Extensions are treated as public APIs for the type that's extended by the extension. As such, you can't have a `pri` function in an extension. You can't have a `pub` fn either for the same reason. To use functions from an extension, you need to import the extension first. Note that you don't need to import extensions that get used implicitly (you don't need to import `Into` if you use the `as` keyword for example).

=== What can go in an extension

Extensions can have:
1. function call signatures
2. complete functions that can be overwritten
3. constant signatures

```
extension ExampleExtension {
	// Constant signature. Must be filled when extending a type with this extension
	const int EXTENSION_CONST

	// Function signature
	fn func1(*self) -> int

	// Function with a body. This can be overwritten when extending using this extension, but must keep the same function signature
	fn func2(*self) -> str {
		return <Self as ExampleExtension>::func1(self) as str
	}
```
