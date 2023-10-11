#import "../prelude.typ": *

== The actual lexer
#local_outline()

Something important to note here, is that although the majority of this chapter has been devoted to describing the NFA we can use to recognise fck, you may have noticed some omissions; namely:
- Comments
- Spaces, tabs, and newline
- Not mentioned but curly braces

These are not handled by the NFA, and in fact, the language is not recognised by an NFA entirely and has a second part.

=== Language scoping

fck is _language scoped_ meaning blocks have languages. For example, consider the following

```fck
!!en
/* some English code */
!!de
/* some German code */
!!en
/* back to English code */
```

Here we're imagining that the German code (ln 3-4) was added into a block of English code with the second #raw(lang: "fck", "!!en") being added in at the end of the German code. However, this may not always be easy. If the first block of English code (ln 2) is quite long, it may be quite tedious to find the current language, and missing out changing back to the previous language would cause the code to be parsed incorrectly#footnote[The code would be parsed correctly, but we would consider it incorrect because we missed out changing the language back]. Because of this, the current language is scoped. Instead of the above code, a more sensible addition would be the following

```fck
!!en
/* some English code */
{
!!de
/* some German code */
}
/* back to English code */
```

Notice how we don't need a second #raw(lang: "fck", "!!en") since the German is contained within a block, and thus won't change the language of the block above it.

=== NFA branch parsing

When parsing some input, we parse $cal(L)^*$ where $cal(L)$ is the set of all valid single tokens. We parse input using a maximal-munch tokenization method meaning we always try to find the longest token. This subsection will use formal language theory notation heavily.

Consider some input $i=i_1i_2i_3...i_n$ and some set of tokens $T$, along with some matcher $m:Sigma^+ -> T union {nothing}$. The NFA simply moves through $i$ character by character until it finds some $k in (1,n]$ s.t. $m(i_(1..k)) in T$. At this point, we have that $exists k'>k$ s.t. $m(i_(1..k')) in T$ or the inverse, that $exists.not k'>k$ s.t. $m(i_(1..k')) in T$. However, we don't know which of these is true, and we want to avoid having to go backwards in $i$. to deal with this, we create a _branch_. This branch assumes that $exists.not k'>k$ and thus $i_(1..k)$ is the longest match for any $k$. It then restarts the parsing process from $i_(k+1)$. We also continue checking if $exists k'>k$. If we do find some $exists k'>k$, then we delete the branch and make a new one.

To demonstrate, consider lexing #raw(lang: "fck", "set"). We start with one main branch. This then gets given an `s`. `s` is a valid identifier, but it could also be longer, so we make a branch. We then give `e` to the main branch. This means the main branch has `se` which is also a valid identifier and so we need a new branch. Since `se` is longer than `s`, we remove the previous branch and replace it with `se`. We then finally give the main branch `t` which means it now has `set` which is a keyword so it makes a new branch as before. We've now reached the end of the input so we traverse through the branches until we find one with no unmatched input and use the tokens it has matched.

#note[*example here please thanks*]

=== Why we need a second part

Because fck is language scoped, if we wanted to parse the language entirely using an NFA, we would need the NFA to:
1. Recognise when the language has changed
2. Add in the appropriate language to itself
3. Revert back to the previous language when a scope ends

NFAs cannot do this. As such, some tokens are parsed manually; those tokens being those mentioned at the start of this section.

/ Spaces: Spaces are parsed manually because it means we can ignore them. Spaces are only used to separate keywords and identifiers from each other, and newlines indicate the end of an expression, so we can just skip over them, performing the appropriate method each time.
/ Comments: Because spaces are parsed manually, we can't parse anything with a space in it with the NFA. Comments are allowed to contain spaces and thus must be parsed manually.
/ Curly braces: These need to be parsed manually because open(closed) curly braces indicate the start(end) of scopes.
/ Language changes: These have to be parsed manually to allow us to change language when needed.

The reasoning for not parsing spaces may seem a bit strange. So, let's explain it a bit further. Consider the following code

```fck
set a = 5
!!de
setz b = 9
```

#note[We're assuming that we start in English. We normally state this a the first line for good practice, but we're not here. This is an exception.]

As a reminder, we parse an input using the NFA until it either fails or ends with no branches. If the NFA could parse spaces, then we would parse the entire example input, with the language change to German (ln 2) not being parsed as a language change, but as two `TokType::Not` tokens and an identifier after it. By not parsing spaces, we ensure that we always capture language changes since they must be at the start of a line, so we'd never have started parsing something else before we get to them.
