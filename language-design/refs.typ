== Pointers and cloning

Types in fck are implicitly make cloneable, that is you can make a clone#footnote[Clone is used, not copy, to indicate that the cloned value is a copy of the original, but separate from it after being cloned.] of any value whenever you want. However, cloning can be expensive sometimes. Cloning can be done implicitly (@refs-implicit-clone), or explicitly (@refs-explicit-clone).

#figure(caption: [Implicit cloning])[
```fck
set value = 1;
some_function(value)
value++
```
]<refs-implicit-clone>

#figure(caption: [Explicit cloning])[
```fck
set value = 1;
some_function(value.clone())
value++
```
]<refs-explicit-clone>

Pointers are passed by prefixing the variable with a `*` in the style of C-like code (@refs-pointers).

#figure(caption: [Implicit cloning])[
```fck
set value = 1;
some_function(*value)
value++
```
]<refs-pointers>

== Mutability

All values are mutable. Only constants are immutable.
