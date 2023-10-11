#import "../prelude.typ": *

== NFA generation <lex-nfa_gen>
#local_outline()

This section will discuss the generation of the NFA from a given language file.

=== Initialization

The NFA is #code("lang/const_builder.py", name: "initialized") with some standard transitions. These are for operators and comparisons only since these are the only things that are constant between languages.

The next thing we add, which is still considered initialization, is brackets. This does not include curly brackets (`{` and `}`) since these are handled differently because they indicate block start and ends. Brackets are not constant because they depend on the direction the language is writen in. If the code is left to right (LTR), then the bytes for square brackets will be 91 and 93 for open and closed brackets respectively. In a right to left (RTL) language, these bytes will be reversed with 93 for open and 91 for closed.

We also initialise an identifier state which we will refer to as $q_i$. This is initialized here because it will be required when adding in keywords for unmatched keywords to go to, so we need to have a state here to go to.

=== Keywords

#note[Whilst we refer to the lexer using an NFA, this is not quite accurate. The lexer uses what we will refer to as a _restricted NFA_. This is the same as an NFA with the only difference being that we have a different definition of the transition function $delta:Q -> Q union {nothing}$ with the definition for $delta^*$ following from this. The reason for this will be explained later.]

To encode the keywords in the NFA, we go through each keyword $k in K$ ($K$ being the set of all keywords) we need to accept and do the following:
1. Find the longest prefix $p$ of $k$ s.t. $delta^*(q_0,p)!= nothing$. $p!=k$ since this would require that $exists k_1,k_2 in K$ where $k_1=k_2$ which is not true
2. For each byte $k_n$ in $k$ where $n > |p|$, make a new state $q'$ with a transition from $delta^*(q_0,k_(1..n-1))$ to $q'$ requiring $k_n$ (i.e. $delta^*(q_0,k_(1..n)=q'$)

Once complete, the NFA will accept all keywords in $K$.

However, it will not accept identifiers with prefixes that match prefixes of keywords. Formally, the NFA will not accept any $a=b c in Sigma^+$ where $exists k in K$ s.t. $k=b d$ for some $d in Sigma^+$ and $|b|>0$. To fix this, we again go through each keyword $k in K$ and for each $n in [1,|k| ]$, add the transition from $delta^*(q_0,k_(1..n))$ to $q_i$ for all allowable byte extensions of $k_(1..n)$. This means we allow extensions of $k_(1..n)$ that would be an identifier, and not indicate a different token. For example, we would not allow a transition from $delta^*(q_0,k_(1..n))$ to $q_i$ for the byte 43, since this is a `+` and would be either a plus, plus equals, or increment token. This is not done in two separate steps and was only written this way to make this simpler to understand.

=== Digits

Digits are more complicated that keywords. Digits are specified in language files, and a single digit can be multiple bytes long. This means that we could potentially require several states to recognise a single digit.

@lex-nfa_gen-fig1 gives the general structure of states for accepting a valid digit. You may notice something interesting here; namely that this accepts any string of digits followed by a single `.` as a float without the requirement for a trailing `0`. This is intentional. Consider #raw(lang: "fck", "set a = 1.") and #raw(lang: "fck", "set a: float = 1"). Both do the same thing, but differently. The first uses the trailing `.` to indicate a float, whereas the second explicitly states the type of `a`. Both are valid, but I find the first simpler to write and so included it.

#include "1_digits.typ"

#note[An important note about @lex-nfa_gen-fig1. The labels on the transitions are not absolute, but representative of matching the equivalent of that for some general language. The transitions relating to hexidecimal numbers also accept uppercase letters if they are provided in the language file]

The #code("lang/lang-inner/src/tables/digits.rs", name: "code") for this is split into two parts; one where all digits are a single byte long, and one for all other digits. The single digits are relatively simple to add in because we're just following the diagram in it's simplest form. When the digits are multiple bytes long, we need to add several additional states. Specifically, if the digits are all $n+1$ bytes long, we need an additional $82n$ or $94n$ states, plus any additional bytes for the prefixes for binary, hexidecimal, or octal numbers, depending if the language has uppercase hexidecimal digit variants.

Also, when adding multi-byte digits into our NFA, we need to consider partial matching. Consider the digit $d=a b in D$ where $a,b != epsilon$ and $a in.not D$. If we match $a$ with no $b$, then we have matched an identifier. However, consider another $d'=c d in D$ where $c,d != epsilon$ and $c in.not D$. If we matched $d c$, this would be two separate tokens (matching $d$ and $c$) since identifiers cannot start with a digit. Thus, for multi-byte digits, we must include a default transition to $q_i$ when matching a digit from $q_0$ to either $d$ (state) or $d_0$.

One important note here is that if we match a digit, we only know that we have a digit, and not it's value. Encoding this in an NFA would be practically impossible since we have an upper bound on the number of states in code. Instead, we decode the matched digit by comparing the matched byte stream with the digits bit-by-bit until the whole matched section has been matched with a digit stream. This is then converted to a number (integer of float) depending on the base of the number. This means that for all the digits $d in D$, it must hold that $exists.not d_1,d_2 in D$ s.t. $d_1=d_2 alpha$ for some $alpha in Sigma^+$. If this were true then when decoding the matched bytes we may match the start of the unmatched section as $d_2$ when it was actually $d_1$. This would leave $alpha$ prefixing the remainder of the unmatched section which could either mean that we cannot match the unmatched section, or that we match an incorrect digit if $alpha$ is the prefix of some other $d_3 in D$. Either outcome is incorrect.
