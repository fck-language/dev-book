#import "@preview/tablex:0.0.5": tablex

= Language file specification <apdx-lang_spec>

This appendix contains the specification for the fckl language format. It is seperated into a numbered list, with the n#super[th] element being for the n#super[th] line of the language file.

fckl language files do not have the ability to include comments. Blank lines will also cause errors when not specified.

== Terminology

fckl language files use spaces to determine term separation (UTF-8 0x26). This byte may be repeated multiple times between terms.

The term 'character' refers to a #link("https://www.unicode.org/glossary/#unicode_scalar_value")[Unicode scalar value].

== Specification<apdx-lang_spec-spec>

#enum(
[This line is split into three parts:
#enum([An opening curly bracket. This is used to determine if the language is LTR or RTL], [The full name of the language], [The code for the language. This should match the name of the file with no file extension])],
[This is split into three main parts:
#enum(
[Three characters representing the number prefixes for (in order) binary, hexidecimal, and octal],
[16 characters for digits from zero to nine followed by the hexidecimal digits for values from 10 to 15],
[An optional additional six digits for the uppercase variants of the hexidecimal digits for values from 10 to 15]
)],
[Keywords for:
#tablex(
	columns: (25%,) * 4,
	auto-lines: false,
	map-cells: cell => {
		(..cell, content: enum(start: cell.x + cell.y * 4 + 1, raw(lang: "fck", cell.content.text)))
	},
	"set", "and", "or", "not",
	"if", "else", "match", "repeat",
	"for", "in", "to", "as",
	"while", "fn", "return", "continue",
	"break", "where"
)],
[Keywords for:
#tablex(
	columns: (25%,) * 4,
	auto-lines: false,
	map-cells: cell => {
		(..cell, content: enum(start: cell.x + cell.y * 4 + 1, raw(lang: "fck", cell.content.text)))
	},
	"struct", "properties", "enum", "variants",
	"self", "Self", "extension", "extend",
)],
[Keywords for:
#tablex(
	columns: (100% / 3,) * 3,
	auto-lines: false,
	map-cells: cell => {
		(..cell, content: enum(start: cell.x + cell.y * 3 + 1, raw(lang: "fck", cell.content.text)))
	},
	"int", "uint", "dint", "udint",
	"float", "bfloat", "str", "char",
	"list", "bool"
)

Note: See @lang_design-primitives for descriptions of the primitive types.],
[#set raw(lang: "fck");Constants for `true` and `false`],
[Delimiters for a string and character (string start, string end, character start, character end)]
)

== English language file

The below code is the English fckl language file. This is included to aid with understanding the specification.

The line numbers are not part of the file and are purely to aid with comparing the file with the specification

```lineno
{ English en
b x o 0 1 2 3 4 5 6 7 8 9 a b c d e f A B C D E F
set and or not if else match repeat for in to as while fn return continue break where
struct properties enum variants self Self extension extend
int uint dint udint float bfloat str char list bool
true false
package name src tests benches type lib app version authors github gitlab email license description readme homepage repo features dependencies usage git branch path dev build main
Compiling Building Built Linking Emitted Error errors Warning warnings
e0001 placeholder
e0002 placeholder
e0003 placeholder
e0004 placeholder
e0005 placeholder
e0006 placeholder
e0007 placeholder
e0101 placeholder
e0102 placeholder
e0201 placeholder
e0202 placeholder
e0203 placeholder
e0204 placeholder
e0205 placeholder
e0206 placeholder
e0207 placeholder
e0208 placeholder
e0209 placeholder
e0301 placeholder
e0401 placeholder
e0402 placeholder
fck command line interface
new
Generate a new project
shell
Run the shell
build
Build the specified project or file
run
Run the specified project after (optionally) building
test
Test the given project using all or some tests
info
Get info about the current fck version
lint
Lint a project depending on the style file
raw
Run a raw piece of fck code
doc
Generate the documentation for a project
translate
Translate a file or project into a target language
help h
Show help information
path p
Path to file or directory
git g
Initialise the new project as a git repository
dump-llvm d
Dump the LLVM IR to a file
no-build n
Don't build before running the command
test t
Path like string to a specific file module or test function to run. Can be given more than once
raw r
Raw string to run
target l
Language to translate the code into
output o
Path to output the translated file to
comment c
Include the comments in translation using LibreTranslate
```
