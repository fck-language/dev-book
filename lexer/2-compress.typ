#import "../prelude.typ": *

== Storing an NFA <lex-store>
#local_outline()

The primary way to store an NFA $M$ is to store its _adjacency matrix_. This is an $m times n$ matrix of 0s and 1s (formally ${0,1}^(m times n)$) where $m=|Sigma|$ and $n=|Q|$, that encodes an NFAs states, initial state, transition function, and $Sigma$#footnote[Encoding $Sigma$ here really means that we assume that $Sigma$ has some mapping $m:Sigma -> [1,|Sigma| ]$ that we have also encoded or is already known]. We also store $F$ as a set of values from 1 to $n$ inclusive for which the state is accepting.

This is generally good enough. However, it will only allow us to check if some input $a$ is in $cal(L)(M)$. We need a bit more than this. We need to know for a given $a in cal(L)(M)$ what kind of token matches $a$. For this reason, we store three matrices all of the same shape. These are as follows:
1. A transition ($Delta$) table
2. Token type ($"TT"$) table
3. Token descriptor ($"TD"$)#footnote[This name may seem strange, and it is a bit. The original meaning has been forgotten, but the term `td` is used so much throughout the codebase that changing it would be more effort than it's worth] table

#notation[We're going to go back to indexing starting at 0 now. We're also going to define $K(r,c)$ as the element in row $r$ and column $c$ for a table $K$.]

The transition table encodes $delta$. If $Delta(5,3)$ was a 9, we would go to row 9. The TT tells us if we've matched a token, and what type of token it is. Using $(5,3)$ again, if $"TT"(5,3)$ was non-zero, that would mean we've matched a token. In this case, we use $"TT"(5,3)$ and $"TD"(5,3)$ to determine what kind of token has been matched (see @apdx-tok-tt_td for the specific TT,TD value pairs).

=== Table compression

All of the tables are really sparse, or not dense. We formally define density as the proportion of the table that does not have the most common value. More simply for us, the proportion of non-zero elements since zero will be the most common value. Currently, the densities for the English $Delta$, $"TT"$, and $"TD"$ are 0.67708%, 0.49154%, and 0.47526% respectively#footnote[The tables each have 208, 151, and 146 non-zero elements out of a total of 30720 elements respectively] which would result in large quantities of data being wasted entirely with only a small amount of useful data. So, we need to compress the tables.

There are a few ways to do this. We'll consider three:
1. Single stream duplicate compression
2. Multi-row group compression
3. Single stream unique compression

To fully explain these, we'll use @tab-example_compression as our sample table to compress. This table has not row numbers or column headings. These aren't necessary for here so they haven't been included.

#figure(caption: [Sample table for demonstrating compression methods], kind: "Table", supplement: "Table")[```
0 2 3 4 1 0 0
1 0 0 2 0 0 2
0 0 0 4 0 4 0
0 2 3 0 2 0 0
1 0 0 0 3 0 0
```]<tab-example_compression>

We will use $K$ to refer to the example table. We will also use examples when exapling the compression methods. Each example will be accessing $K(r,c)$ and we will use $r$ and $c$ to denote general rows and columns.

==== Single stream duplicate compression

This compression method compresses the table into a single row where each row is offset to that when merged only zeros are replaced and duplicates can be merged. To explain, we'll offset the rows:

#figure(caption: [Offset rows for single stream duplicate compression], kind: "Table", supplement: "Table")[```
0 | 0 2 3 4 1 0 0
4 |         1 0 0 2 0 0 2
0 | 0 0 0 4 0 4 0
6 |             0 2 3 0 2 0 0
4 |         1 0 0 0 3 0 0
```]

You'll notice that in each column, there is either only zeros, or some number of zeros (possible none) and one non-zero value at least once. This means that we can merge these offset rows into a single stream. To do this, we need to save the row offsets as well as a bitmap of the original table. When we try to access an element in this stream, for example $K(3, 4)$ using $K$ to denote our sample table, we first check if the value in the bitmap is 1, indicating that a non-zero element is there in the original table. If it was 0, we would return a 0. Once we've checked that there's a value there, we get the row offset $O(r)$, which is 6 in our example. We then access the element at $O(r)+c$, 10 in our example, to get the element we want.

==== Multi-row group compression

This method doesn't offset rows, but instead groups them into groups of rows that can be merged using the same merging rules as single stream duplicate compression. When applied to our sample table, we get the following groups (with the row index prefixing the row):

#figure(caption: [Row groups for multi-row group compression], kind: "Table", supplement: "Table")[```
0 | 0 2 3 4 1 0 0
2 | 0 0 0 4 0 4 0

1 | 1 0 0 2 0 0 2
3 | 0 2 3 0 2 0 0

4 | 1 0 0 0 3 0 0
```]

We then merge each group of rows into a single row, saving what new row each original row went into along with a bitmap of the original of table. When getting an element, we first check the bitmap. If we're expecting a value, we then go to the new row for the row we wanted, and then the column we wanted.

I find this method to perform worse than single stream duplicate compression.

==== Single stream unique compression

This method is very similar to single stream duplicate compression, but it does not allow rows to be merged if it would involve merging duplicate non-zero elements. The offset rows for this method would be as follows:

#figure(caption: [Offset rows for single stream unique compression], kind: "Table", supplement: "Table")[```
 0 | 0 2 3 4 1 0 0
 5 |           1 0 0 2 0 0 2
 4 |         0 0 0 4 0 4 0
11 |                       0 2 3 0 2 0 0
 6 |             1 0 0 0 3 0 0
```]

Notice that each column has either only zeros, or some number of zeros and one non-repeated non-zero value. This method means that we don't have to save a bitmap and can instead use an _origin map_. The origin map tells us which row each value in the compressed stream came from. If we added the origin map onto the offset rows we would have the following:

#figure(caption: [Offset rows for single stream unique compression with an offset map], kind: "Table", supplement: "Table")[```
 0 | 0 2 3 4 1 0 0
 5 |           1 0 0 2 0 0 2
 4 |         0 0 0 4 0 4 0
11 |                       0 2 3 0 2 0 0
 6 |             1 0 0 0 3 0 0
     0 0 0 0 0 1 4 2 1 2 4 1 3 3 0 3 0 0
```]

#note[You'll also notice that columns of entirely zeros have an origin of zero. This could be any row in reality since we'd give zero regardless, but having it as zero makes the code slightly quicker.]

To access an element such as $K(1, 3)$, get the offset of the row $O(r)$ which is 5 in our example. We then set $c':=O(r)+c$. If $S[c']=r$ where $S[i]$ is the $i$-th element in the origin stream, then we return $C[c']$ where $C$ is the compressed stream.

The #code("lang/lang-inner/src/compress/unique_stream.rs", line: (176, 188), name: [code]) for this is as follows (from inside a trait impl):

```rs
fn element(&self, row: u16, col: u8) -> D {
    let index = self.offsets[row as usize] + col as usize;
    if self.origin[index] == row { self.stream[index] } else { *D::ZERO }
}
```

#note[`D` is a generic here. The trait impl is for a generic `D` which is the return type of the function `element`.]

==== The best one

Out of the three, single stream unique compression was by far the best method. It frequently compressed the tables smaller than the others, and had the fastest element access by far. I did not consider a unique variant of multi-row group compression since this method was almost always the worst performing. As such all tables are compressed using single stream unique compression, which we'll now call UStream compression.

When applied to the English tables with original sizes of 122880 bytes for $Delta$ and 61440 bytes for $"TT"$ and $"TD"$, they were compressed down into 2604 bytes for $Delta$ and 2049 for $"TT"$ and $"TD"$ which is ~4.24% and ~3.33% of the original sizes.

#note[One addition method used to compress the tables is that the types in the tables are quite specific. Token TT and TD values have been designed so that they fit into the range for a #raw(lang: "rust", "u8"), so we can store the values in $"TT"$ and $"TD"$ in a single byte. We also assume that we will never have more than $2^16$ states, so we can store the values in $Delta$ as #raw(lang: "rust", "u16")s which are smaller that #raw(lang: "rust", "usize")s which is what we would have previously used.]
