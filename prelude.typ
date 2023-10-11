#let code(path, line: none, name: none) = {
	if line != none {
		let (line_str, line_str_fmt) = if type(line) == type(()) {
			("#L" + str(line.at(0)) + "-#L" + str(line.at(1)), str(line.at(0)) + "-" + str(line.at(1)))
		} else { ("#L" + str(line), str(line)) }
		if name == none {
			text(purple, link("https://github.com/fck-language/fck/blob/master/" + path + line_str)[#raw(path + ":" + str(line))])
		} else {
			text(purple, link("https://github.com/fck-language/fck/blob/master/" + path + line_str)[#name])
		}
	} else {
		if name == none {
			text(purple, link("https://github.com/fck-language/fck/blob/master/" + path)[#raw(lang: none, path)])
		} else {
			text(purple, link("https://github.com/fck-language/fck/blob/master/" + path)[#name])
		}
	}
}

#let note(content) = {
	rect(fill: luma(60%), width: 100%, inset: 0pt)[#align(right)[#rect(width: 100%-2pt, fill: luma(95%))[#align(left)[#content]]]]
}

#let notation(content) = {
	rect(fill: rgb(0%, 0%, 100%).lighten(50%), width: 100%, inset: 0pt)[#align(right)[#rect(width: 100%-2pt, fill: rgb(0%, 0%, 100%).lighten(90%))[#align(left)[*Notation*:\ #content]]]]
}

#let local_outline(depth: calc.inf) = {
	locate(loc => {
		let pre = query(selector(heading).before(loc), loc)
		if pre == () { return }
		let min_level = pre.last().level
		let max_level = min_level + depth
		let elems = query(selector(heading).after(loc), loc)
		let inner_elems = ()
		for e in elems {
			if e.level <= min_level { break }
			else if e.level <= max_level { inner_elems.push(e) }
		}
		inner_elems.map(i => [#link(i.location(), [#numbering(i.numbering, ..counter(heading).at(i.location())) #i.body]) #box(width: 1fr, repeat[.]) #i.location().page()]).join("\n")
	})
}
