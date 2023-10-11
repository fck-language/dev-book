#import "@preview/minitoc:0.1.0": *
#set raw(lang: "fck")

= Language Design

#minitoc(target: heading.where(level: 2))

#for mod in ("primitives", "refs", "data-types", "vis", "extensions", "iteration") { include mod + ".typ" }

#set raw(lang: none)
