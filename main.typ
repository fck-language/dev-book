#import "template.typ": *

// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: theme.with(
	title: "fck Developer Book",
	authors: ("nxe",),
	version: "v0.1.0",
	intro: [
This book has been written to accompany the fck compiler and CLI. It will go through design choices of the language and implementations for the compiler. This book is not intended to teach you how to write a programming language and assumes some basic knowledge in the subject.

Before you start, some notes. Firstly, the above contents are not exhaustive, they include only main headings. Each section will have a sub-contents that lists all the second level headings inside it, with each of the second level headings listing all sections inside it. Secondly, the terminology used in this book regarding languages is quite specific. The term _language_ will refer to the fck programming language (or a more general programming language; whereas _spoken language_ will refer to a non-programming language that is spoken and written, such as Spanish.

This book is for version 0.1.0 of fck and was completed in #datetime.today().display("[month repr:long] [year]").
	]
)

#for base in ("intro", "language-design", "lexer") {
	include base + "/main.typ"
	pagebreak()
}

#include "appendices/main.typ"
