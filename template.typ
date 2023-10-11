// The project function defines how your document looks.
// It takes your content and some metadata and formats it.
// Go ahead and customize it to your liking!

#let theme(title: "", authors: (), version: none, intro: [], toc: true, newpage: true, body) = {
	// Set the document's basic properties.
	set document(author: authors, title: title)
	set page(numbering: none, number-align: center)
	set text(font: "Avenir Next", lang: "en", size: 12pt, hyphenate: false)
	set heading(numbering: "1.1")

	// Title row.
	align(center)[
		#block(text(weight: 700, 1.75em, title))
		#v(1em, weak: true)
		#version
	]

	// Author information.
	pad(
		top: 0.5em,
		bottom: 0.5em,
		x: 2em,
		grid(
			columns: (1fr,) * calc.min(3, authors.len()),
			gutter: 1em,
			..authors.map(author => align(center, strong(author))),
		),
	)

	if toc {
		text(weight: "bold", size: 18pt, baseline: 12pt)[Contents]
		outline(target: heading.where(numbering: "1.1"), depth: 1, title: none)
		text(weight: "bold", size: 18pt, baseline: 12pt)[Appendices]
		outline(target: heading.where(numbering: "A.1"), title: none, depth: 1)
	}

	if intro != [] {
		heading(outlined: false, numbering: none, "Preface")
		intro
	}

	// Main body.
	set page(
		header: locate(loc => {
			if calc.rem(loc.page(), 2) == 0 {
				align(left)[#emph(title)]
			} else {
				align(right)[#emph(title)]
			}
		}),
		numbering: "1", number-align: center
	)
	let kwds_mapping = (
		"set": "setz",
		"and": "und",
		"or": "oder",
		"not": "nicht",
		"if": "wenn",
		"else": "sonst",
		"match": "paaren",
		"default": "default",
		"iterate": "wieder",
		"import": "importiere",
		"while": "solange",
		"def": "def",
		"return": "rück",
		"continue": "fortsetze",
		"break": "brechen",
		"as": "als",
		"in": "in"
	)
	let kwds2_mapping = (
		"pub": "öffentlich",
		"alias": "alias",
		"class": "klass",
		"properties": "eigentum",
		"enum": "gezählt",
		"variants": "varianten",
		"derived": "abgeleitet",
		"extension": "extension",
		"extend": "strecken",
		"with": "mit",
	)
	let types_mapping = (
		"int": "ganze",
		"float": "gleit",
		"bool": "bool",
		"str": "str",
		"list": "liste",
		"map": "map",
		"true": "wahr",
		"false": "falsch"
	)
	let self_mapping = ("self": "selbst", "Self": "Selbst")

	let mapping = (:..kwds_mapping, ..kwds2_mapping, ..types_mapping, ..self_mapping)

	show raw.where(block: false): it => if it.lang == none { text(it) } else {
		box(
			fill: rgb("#1d2433"),
			inset: (x: 3pt, y: 0pt),
			outset: (y: 3pt),
			radius: 2pt,
			text(fill: rgb("#a2aabc"), it)
		)
	}

	set raw(syntaxes: "fck-syntax.sublime-syntax", theme: "code-theme.tmTheme")
	show raw.where(block: true): it => if it.lang == none { align(center, it) } else {
		block(
			fill: rgb("#1d2433"),
			inset: 8pt,
			radius: 5pt,
			width: 100%,
			align(left, text(fill: rgb("#a2aabc"), it))
	    )
    }
	// align(left) is a hack to make sure it's aligned left in figures

	body
}
#import "prelude.typ": *
