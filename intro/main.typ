#import "../prelude.typ": *

= Introduction
#local_outline()

This section will give a brief introduction into fck. Namely:
1. Justify the need/desire to have a multi-lingual language (@intro-just)
2. Explain how the multilingual aspect functions from a user perspective (@intro-how)

== Justification <intro-just>

Programming languages are almost entirely written for English speaking programmers. There are very few languages that can be written, without the need for external files, in any other spoken language than English. For completeness, we will discuss one such language in @intro-citrine.

The world is increasingly becoming more and more reliant on technology, and having programming be reliant on knowing English seems a bit wrong. As an interesting note related to this, approximately two billion people speak English, or around 25% of the world population.

This is why I made fck. To allow more people to write code, and to allow more collaboration through code.

=== Citrine <intro-citrine>

#link("https://citrine-lang.org/")[Citrine] is the only real example I could find of a multilingual language. Personally, I find some aspects of Citrine to hinder it:
#enum(
[*Use of icons*\
The designers of Citrine cite Smalltalk-70 as one of their design inspirations, and have taken the usage of icons into their language. This, I believe, is one of the weakest points of the language. The usage of icons can be quite helpful in some situations. One notable example is APL which is famous, or infamous, for being completely incomprehensible to anyone who doesn't know what any of it means. For example, `(((≢×+.*∘2)-2*⍨+⌿)÷≢×1⌈¯1+≢)Nv` is valid APL to determine sample variance. To many, this is incomprehensible; but to those who know APL, this makes sense. Citrine does something similar, in that it uses a few icons for repeated things, such as `self` or to indicate that a value is owned by a class and is private. To me, this is different to APL. APL leans heavily on the use of icons as a feature of the language and has created something quite interesting; Citrine's use of icons seems more like a gimmick than a useful feature, and just places undue effort on the user to set up.],
[*Minimal language configurability*\
Citrine only has built-in languages. This means you cannot add in an unsupported language without building the language from source which can often be quite time-consuming. Citrine also, so far as I can tell, will only allow you to write code in one language and as such requires downloading a language specific binary instead of a general purpose one.],
[*Interpreted not compiled*\
Citrine is an interpreted language. This does reduce the overhead for building the language from scratch, but also requires any computer to have the interpreter for the correct language if you want to run code on it.],
[*General ecosystem*\
The Citrine ecosystem is greatly lacking in any form of documentation of help. There is little documentation and very little to no description of the language beyond what it looks like. No getting started guide to help with the setup, and simple things like passing a `-h` or `--help` flag to the interpreter not giving any help messages. Whilst arguably trivial, I personally see these are large issues for a language with it's first non pre-release version having been released in February 2018.]
)

== How it works <intro-how>

fck works as a general purpose compiler and JIT interpreter through LLVM. It uses a mixture of built-in languages and optional custom languages from language files. There is one binary that handles all the compilation, linting, testing, and documentation. There is a requirement for a `~/.fck` file to specify the default language to be used.

=== Language files

The language files are simple text files that define a language. These are fairly simple files, and all follow the same format (the specification is defined in @apdx-lang_spec). All available built-in languages are included by reading their language files at compile time.

The languages all go through a validation process to ensure that:
1. They make sense
2. Comply with some restrictions that make parsing them easier

The first point is mainly just ensuring that there are no repeated keywords or symbols, ensuring that everything is unique. The second point imposes some small restrictions on language files that we can then assume is true when making the lexer. The restrictions are detailed in the @apdx-lang_spec[specification].

Finally, one term comes from this: "uppercase hexidecimal digit variants". Part of the language file includes specifying the digits of the language from zero to nine, as well as hexidecimal digits for 10 to 15 (`a` to `f` in English). You may also wan to specify uppercase variants for these digits (`A` to `F` in English). These uppercase digits are referred to as _uppercase hexidecimal digit variants_.
