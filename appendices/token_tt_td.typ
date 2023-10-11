#page(flipped: true, margin: (left: 8mm, right: 8mm))[
#import "@preview/tablex:0.0.5": tablex, rowspanx, colspanx, cellx, hlinex, vlinex
== Token (TT, TD) pairs <apdx-tok-tt_td>

#figure(caption: [TT and TD value pairs for token types], kind: "table", supplement: "Table", [
#set text(size: 8pt)
#tablex(
	columns: (auto,) * 17, align: center + horizon, auto-lines: false,
	hlinex(start: 2, end: 17),
	vlinex(start: 2, end: 15), rowspanx(2, colspanx(2, [])), vlinex(start: 2, end: 10), (), vlinex(start: 0, end: 15), hlinex(start: 2, end: 17), colspanx(15, [TD]),
	(), (), vlinex(start: 0, end: 10), [0], vlinex(start: 0, end: 10), [1], vlinex(start: 0, end: 10), [2], vlinex(start: 0, end: 10), [3], vlinex(start: 0, end: 10), [4], vlinex(start: 0, end: 10), [5], vlinex(start: 0, end: 10), [6], vlinex(start: 0, end: 10), [7], vlinex(start: 0, end: 10), [8], vlinex(start: 0, end: 10), [9], vlinex(start: 0, end: 10), [10], vlinex(start: 0, end: 10), [11], vlinex(start: 0, end: 10), [12], vlinex(start: 0, end: 10), [13], vlinex(start: 0, end: 10), [255], vlinex(start: 0, end: 15), hlinex(start: 0, end: 17),
	rowspanx(10, [TT]), vlinex(start: 2, end: 15), [1], [`Bool(true)`], [`Bool(false)`], [`Int` base 10], [`Int` base 2], [`Int` base 16], [`Int` base 8], [`Float`], [`String`], [`Char`], colspanx(6, fill: gray, []), hlinex(start: 1, end: 17),
	(), [2], [`Op(Op::Plus)`], [`Op(Op::Minus)`], [`Op(Op::Mod)`], [`Op(Op::Mult)`], [`Op(Op::Div)`], [`Op(Op::Pow)`], [`Increment`], [`Decrement`], [`Not`], [`Colon`], [`QuestionMark`], [`Dot`], [`Arrow(Single)`], [`Arrow(Double)`], cellx(fill: gray, []), hlinex(start: 1, end: 17),
	(), [3], [`Cmp(Cmp::Eq)`], [`Cmp(Cmp::NE)`], [`Cmp(Cmp::LT)`], [`Cmp(Cmp::GT)`], [`Cmp(Cmp::LTE)`], [`Cmp(Cmp::GTE)`], colspanx(9, fill: gray, []), hlinex(start: 1, end: 17),
	(), [4], [`LParen`], [`RParen`], [`LParenCurly`], [`RParenCurly`], [`LParenSquare`], [`RParenSquare`], colspanx(9, fill: gray, []), hlinex(start: 1, end: 17),
	(), [5], colspanx(6, [`Set(Some(Op))`]), colspanx(8, fill: gray, []), [`Set(None)`], hlinex(start: 1, end: 17),
	(), [6], colspanx(14, [`Control Keyword`]), cellx(fill: gray, []), hlinex(start: 1, end: 17),
	(), [7], colspanx(8, [`Data Keyword`]), colspanx(7, fill: gray, []), hlinex(start: 1, end: 17),
	(), [8], colspanx(10, [`Primitive Keyword`]), colspanx(5, fill: gray, []), hlinex(start: 1, end: 17),
	(), [9], colspanx(15, [`Identifier`]), hlinex(start: 1, end: 17),
	(), [255], colspanx(15, [`Comment`]), hlinex(start: 0, end: 17),
)])<tok_tt_td_table>

The `Set` token type contains an #raw(lang: "rust", "Option<Op>") (TD in `0..6`). This is used to represent operations such as `+=` (#raw(lang: "rust", "Set(Some(Op::Plus))")) as well as assignment `=` (#raw(lang: "rust", "Set(None)"). This is also why operators such as `Increment` are not `Op(Op::Increment)` tokens, since this would indicate the possibility of a set increment operator `++=` which does not exist.

The two arrow token types (`Arrow(Single)` and `Arrow(Double)` at (TT, TD) `(2, 12)` and `(2, 13)` respectively) are actually `Arrow(Arrow::Single)` and `Arrow(Arrow::Double)` but have been shortened for compactness.

All the keyword token types take their specific TD value from indexes in the language file specification, which can be found in @apdx-lang_spec-spec#footnote[The indexes are one more than the keyword TD value. For example, `else` would have a (TT, TD) of `(6, 5)`.]. Note that the `Control Keyword` token type is restricted to `0..=17`.

Finally, the `Identifier` and `Comment` token types are indicated as accepting all TD values. This is technically true, since they never check the TD value, but will never see a TD value other than `0`.

The enums for the tokens can be found in

]