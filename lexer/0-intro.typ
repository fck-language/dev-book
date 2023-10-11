#import "../prelude.typ": *

== Introduction

This chapter explains how lexing is handled by the fck compiler. This is a more involved process than for most, and requires a significant amount when compared to much simpler lexers, such as regex-based lexers.

The lexer is very similar to an NFA or nondeterministic finite automata. As such, a good postion of this chapter will be much easier to understand with some knowledge of formal language theory.

This chapter will cover the following key points:
- Generating an NFA from a given language file (@lex-nfa_gen)
- Storing and compressing an NFA (@lex-store)
- The actual process the lexer goes through when lexing an input

This section has one associated appendix: @apdx-tok.

=== What is lexing

For those unaware, lexing is the process of taking the raw code (as a byte stream in our case) and turning this into a token stream. A good analogy here is to consider reading a sentence. A sentence, in it's simplest form, is a stream of characters. But we read it as a stream of words. The process of turing characters into words is analogous to turning bytes into tokens when lexing. Tokens are simply more manageble blocks we can split code into that the compiler can deal with much better.

#set raw(lang: "fck")

As a very simple example, consider the expression `set a = 5`. This is split into four tokens:
1. `set`: A set keyword token
2. `a`: An identifier token
3. `=`: An equals token
4. `5`: An integer token

This is the goal of lexing, or tokenization, and is the subject of this chapter.
