= Lexing

Lexing, or tokenizing, is the process of turing source code into a set of tokens. Tokens in code are analogous to words and punctuation in sentences. Dealing with tokens make parsing much simpler. This is analogous to us reading words in a sentence instead of reading characters on their own; doable, but much more difficult.

#note[The following section uses notation from formal language theory to define the lexing process]

Let $cal(L)$ be our regular language accepting digits (integers and floats with `_` being allowed as a seperator), keywords, identifiers, brackets (`(`, `)`, `[`, and `]` only), operators, and comments. Let $cal(S)$ be a regular language defined as $cal(S)'$ and all operators where
$
cal(S)'=S^+; quad S:={"' '", "'\\t'", "'\\n'"}
$

Any input accepted under $cal(S)'$ we will refer to as whitespace. We finally define the language we want our lexer to accept $cal(A)$ as $cal(A):={cal(S), epsilon}(cal(L)cal(S))^*{cal(L), epsilon}$. This means that we can start by trying to parse from $cal(S)$. If not, we parse the input again on $cal(L)$.

If we were writing a normal lexer, we could use a single DFA. To do this, consider some input $alpha = alpha_1 alpha_2 ... alpha_n$ for which there exists some series of states $q_1,q_2,...,q_n in Q$ such that $q_n in A$. This means that, for a normal DFA $cal(M)$, $cal(L)_(cal(M))$ includes $alpha$. However, we're actually considering $cal(L)_(cal(M))^*$ where $cal(L)_(cal(M))$ also accepts spaces. This means that we need $cal(L)_(cal(M))$ to accept every valid token in our language which is a fairly trivial task. We can then treat our DFA as a directed graph and make an adjacency matrix for it. In reality, we do this at the same time; we make the DFA by building up an adjacency matrix. We also have a second adjacency matrix that's the same shape as our first, but with token data to tell us what type of token we've just identified. This then allows us to remove terminal states, that is any state $q in Q$ for which $delta^*(x)=q$ for some $x in Sigma^+$, $exists.not y in Sigma^+$ s.t. $delta^*(x y) in A$. Notice here that this includes accepting states for which, if we have already accepted $x$, $cal(L)_(cal(M))$ does not include any words longer that $x$ where $x$ is a prefix.

To denote when an input has been accepted, we use our second adjacency matrix. Consider some input $x$ of length $n>=1$ and $q':=delta^*(x_(0..n-1))$. If we then go to the row in the adjacency matrix for $q'$ and the column for $x_n$, we set that value to the value for the token matched by $x$. We then go to the same position in our first adjacency matrix and set that value to 0. This indicates that, when going through the DFA we've either got to a point where the input is unmatched and we return an error, or that we've finished matching the input and we start again.

#note([We use bytes to index our input. This means the DFA holds regardless of encoding and it only gives us 256 columns in our adjacency matrices which is a very manageable width])

An important point here is that we have two addition matrices, not just one. We refer to the three matrices as the transition table, TT (token type) table, and TD (token data) table. The TT table determines the general token type (an operation, or keyword for example) and the TD table determines the sub-type (such as what keyword or what operation). This allows for a more generic parser and more easily extensible tokens.

To give a really simple example, @example_tables shows a really simple example of a valid transition and TT table that will match AAB, BAAB, and CABC.

#figure(
	supplement: "Table",
	caption: [Example set of adjacency matrices for a simple DFA],
	grid(
		columns: (40%,) * 2,
		column-gutter: 10%,
		[#figure(
			supplement: "Table",
			caption: [Transition table],
			grid(
				columns: (25%,) * 4,
				row-gutter: 2mm,
				[   ], [*A*], [*B*], [*C*],
				[*0*], [2], [1], [4],
				[*1*], [2], [0], [0],
				[*2*], [3], [0], [0],
				[*3*], [0], [0], [0],
				[*4*], [5], [0], [0],
				[*5*], [0], [6], [0],
				[*6*], [0], [0], [0],
			)
		)],
		[#figure(
			supplement: "Table",
			caption: [TT table],
			grid(
				columns: (25%,) * 4,
				row-gutter: 2mm,
				[   ], [*A*], [*B*], [*C*],
				[*0*], [0], [0], [0],
				[*1*], [0], [0], [0],
				[*2*], [0], [0], [0],
				[*3*], [0], [1], [0],
				[*4*], [0], [0], [0],
				[*5*], [0], [0], [0],
				[*6*], [0], [0], [2],
			)
		)]
	)
) <example_tables>

the method being used here is called maximal-munch tokenization. This means we match the longest possible token before moving onto trying to match the next one. You can rationalise this by considering a number such as 12.6. If we matched the first valid token we found then started on matching the next token then we'd match the 1 as an integer token, same with the 2, then match the \'.\' as a dot token, and the 6 as an integer token instead of matching the whole thing as a float token.

To do this, we consider the language $L$ as a regular language that accepts all keywords for a given spoken language. We then use a NFA to accept $L^*$. The NFA uses a transition table and two others we'll get to later.

The transition table is generated from a language and has the base type #raw("Vec<[u16; 256]>", lang: "rust"). Each iteration has the following general format

```rust
let row = 0
loop {
  // get the next row
  let next_row = transition[row][next_char as u8]
  // check if it's going to go somewhere
  if next_row == 0 { break }
  row = next_row
}
return token_from_position(row, previous_char)
```

There is more to this (see #code("lang", "src/lib.rs")) obviously, but you can get the general idea of how it works; Move through the table using the nech byte in the input as your row index until you reach the end.

== Table Compression <tab_comp>

Transition tables and token related tables are extremely sparse (densities range from 0.099% to 0.387%), so over 99% of the tables are just 0s. This is an extremely large waste of memory and we can do much better. For this, we have two group

#align(center)[#table(
  columns: (auto, 6cm, 5.5cm), align: left,
  [*Compression name*], [*Description*], [*Element merging criteria*],
  [Unique stream], [This merges table rows into a single stream with row offsets and element origin], [At most one element can be non-zero even if wthey are the same value element],
  [Non-unique stream], [This merges table rows into a single stream with row offsets and a bitmap], [Both elements are the same or at least one element is zero],
  [Row merging], [This merges groups of table rows into a single row with row maps and a bitmap], [At most one element can be non-zero even if wthey are the same value element]
)]

_See @tabl_comp_examples[Appendix] for an example of all the above compression styles_

=== Bitmap compression

When considering the non-unique stream or row merging methods, the largest part of them is the bitmap by far (around 75%) but have the same density as the original table meaning that we're allocating a lot of meory for something that contains very little data. Because of this we might want to compress it. One idea would be to just use one of the compression methods for the bitmap but modified for bits not integers. However this is a bit counterproductive. Why would we pick a compression method that requires additional compression to be useful?

Another consideration that may arise due to the sparsity of the table might be to use a hashset. But we can improve on this idea. A hashset is, at it's core, an array with an interesting indexing function. so what is we were to just use a hashing function, taking the row and column, and gives us a single result.

My first attempt at this was to use a boolean equation generated in the form of CNF(conjunctive normal form) with each row column pair having an associated pair of values that when XORed together would give #raw("(u16::MAX, u8::MAX)", lang: "rust"). However, this on it's own is a pretty bad solution. It's the same, if not worse, that storing all the non-zero positions in the table and checking if the requested elemet is in that list. When compared to just looking in the uncompressed table this method (using non-unique stream compression) was over 250 times slower with similar results when using an uncompressed bitmap, and around 90 times slower than the equivalent unique stream compression. We copuld try to simplify the boolean equation to compress it and make it faster, but we would have to do a lot of compression for this to even become relatively comparable to the next best compression method. For this reason, I gave up on this idea as unrealistic.

#include "digits.typ"

#include "ser_de_spec.typ"

#include "token.typ"