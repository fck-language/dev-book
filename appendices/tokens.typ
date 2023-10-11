#import "../prelude.typ": *
= Tokens <apdx-tok>
#local_outline()

This appendix contains the token enums used by the compiler as well as the TT,TD pairings used to construct tokens.

== Token enums <apdx-tok-enum>

These are not exact copies; they have all comments and derive macros removed. The specific layout too has been altered to take up less space.

```rust
pub enum TokType {
    Int(u64), Float(f64), Bool(bool), String(Vec<u8>),
    Op(Op), Cmp(Cmp), Increment, Decrement, Set(Option<Op>),
    LParen, RParen,
    LParenCurly, RParenCurly,
    LParenSquare, RParenSquare,
    Label(Vec<u8>),
    Not, Colon, QuestionMark, Dot,
    Identifier(String, Vec<u8>),
    Keyword(u8),
    Comment(String, Vec<u8>),
}

pub enum Op {
    Plus, Minus,
    Mod, Mult,
    Div, Pow,
}

pub enum Cmp {
    Eq, NE,
    LT, LTE,
    GT, GTE,
}
```

#include "token_tt_td.typ"
