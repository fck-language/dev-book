== Iteration

Iteration is handled in two main ways in fck. The first method is using the `repeat` keyword, and the second is using the `for` and `in` keywords.

=== Repeat

Repeat statements are a simple way to repeat a block of code any number of times:

```
set reps = 10
repeat reps {
	print("Hello world")
}
```

`repeat` is followed by a variable or literal that tells it how many times it should repeat. You do not have access to a counter of how many times the statement has run without adding one yourself. For this, you can use `for` with a range.

=== For

For statements iterate over a given value:

```
set primes = [2, 3, 5, 7, 11]
for prime in primes {
	print(prime)
}
```

One (possibly) important thing to note here is that iterating over a list in this way can be quite expensive, since `prime` will be clone of each value in `primes`, requiring each value to be cloned each iteration. In essence, the following it happening:

```
set primes = [1, 2, 5, 7, 11]
for i in 0 to primes.len() {
	set prime = primes[i].clone()
	print(prime)
}
```

If you need to make your code run as efficiently as possible, you can iterate over references instead using the `List::iter` function:

```
extend List<T> {
	pub fn iter(*self) -> Iterator<T> { \* ... *\ }
}
```

where `Iterator<T>: Iterable<*T>`.
