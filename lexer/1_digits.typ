#figure(caption: [Simplified NFA for parsing digits], kind: "Figure", supplement: "Figure", {
	let overlay(height, width, ..items) = {
		align(center, rect(fill: none, stroke: none, width: width, height: height, inset: 0mm, grid(rows: 0mm, columns: width, row-gutter: 0mm, column-gutter: 0mm, ..items)))
	}
	let state(name) = circle(fill: white, stroke: black + 1pt, radius: 5mm, align(center, name))
	let a_state(name) = circle(fill: white, stroke: black + 2pt, radius: 5mm, align(center, name))
	let tri(dir: ltr) = {
		if dir == ltr { polygon(fill: black, (-2mm, -1.6mm), (0mm, 0mm), (-2mm, 1.6mm)) }
		else if dir == rtl { polygon(fill: black, (2mm, -1.6mm), (0mm, 0mm), (2mm, 1.6mm)) }
		else if dir == ttb { polygon(fill: black, (-1.6mm, -2mm), (0mm, 0mm), (1.6mm, -2mm)) }
		else if dir == btt { polygon(fill: black, (-2mm, 1.6mm), (0mm, 0mm), (2mm, 1.6mm)) }
		else {
			let c = calc.cos(dir)
			let s = calc.sin(dir)
			let m(a, b) = (a * c - b * s, a * s + b * c)
			polygon(fill: black, m(-1.6mm, 2mm), (0mm, 0mm), m(1.6mm, 2mm))
		}
	}
	set path(stroke: (join: "round"))
	show raw.where(block: false): box.with(
	  fill: luma(220),
	  inset: (x: 0pt, y: 0pt),
	  outset: (y: 3pt),
	  radius: 2pt,
	  height: 3mm
	)
	overlay(6cm, 10.4cm,
		// -> q0
		move(dx: -1cm, dy: 5mm, line()),
		move(dy: 5mm, tri()),
		// q0 -> d0
		move(dx: 1cm, dy: 5mm, line(length: 2cm)),
		move(dx: 3cm, dy: 5mm, tri()),
		move(dx: 1.75cm, [`0`]),

		// q0 -> d
		move(dx: 5mm, dy: 5mm, line(angle: 90deg, length: 3cm)),
		move(dx: 5mm, dy: 3cm, tri(dir: 180deg)),
		move(dx: 6.5mm, dy: 18mm, [`1..9`]),
		// d -> d
		move(dx: 5mm, dy: 35mm, path((0mm, 0mm), (-7mm, 10mm), (7mm, 10mm), (0mm, 0mm))),
		move(dx: 2mm, dy: 39.3mm, tri(dir: calc.atan(0.7))),
		move(dy: 47mm, [`0..9`]),

		// d0 -> d
		move(dx: 5mm + 27mm, dy: 5mm, path((0mm, 0mm), (0mm, 27mm), (-30mm, 27mm))),
		move(dx: 9.3mm, dy: 32mm, tri(dir: rtl)),
		move(dx: 20.3mm, dy: 18mm, [`0..9`]),
		// d0 -> f
		move(dx: 3.5cm, dy: 5mm, line(angle: 90deg, length: 4cm)),
		move(dx: 3.5cm, dy: 40mm, tri(dir: ttb)),
		move(dx: 36mm, dy: 20mm, [`.`]),
		// d -> f
		move(dx: 5mm, dy: 35mm, line(length: 3cm)),
		move(dx: 35mm, dy: 35mm, tri()),
		move(dx: 21mm, dy: 37mm, [`.`]),
		// f -> f
		move(dx: 5mm + 3cm, dy: 35mm + 1cm, path((0mm, 0mm), (-7mm, 10mm), (7mm, 10mm), (0mm, 0mm))),
		move(dx: 2mm + 3cm, dy: 39.3mm + 1cm, tri(dir: calc.atan(0.7))),
		move(dx: 3cm, dy: 47mm + 1cm, [`0..9`]),

		// d0 -> b0
		move(dx: 4cm, dy: 5mm, line(length: 2cm)),
		move(dx: 6cm, dy: 5mm, tri()),
		move(dx: 4.75cm, [`b`]),
		// b0 -> b
		move(dx: 7cm, dy: 5mm, line(length: 2cm)),
		move(dx: 9cm, dy: 5mm, tri()),
		move(dx: 7.55cm, [`0..1`]),
		// b -> b
		move(dx: 9.5cm, dy: 5mm, path((0mm, 0mm), (10mm, -7mm), (10mm, 7mm), (0mm, 0mm))),
		move(dx: 99.3mm, dy: 7.8mm, tri(dir: -calc.atan(10/7))),
		move(dx: 106mm, dy: 3.5mm, [`0..1`]),

		// d0 -> h0
		move(dx: 4cm, dy: 5mm, path((5mm, 0mm), (5mm, 20mm), (20mm, 20mm))),
		move(dx: 6cm, dy: 25mm, tri()),
		move(dx: 51mm, dy: 2cm, [`x`]),
		// h0 -> h
		move(dx: 7cm, dy: 25mm, line(length: 2cm)),
		move(dx: 9cm, dy: 25mm, tri()),
		move(dx: 7.55cm, dy: 2cm, [`0..f`]),
		// h -> h
		move(dx: 9.5cm, dy: 5mm + 2cm, path((0mm, 0mm), (10mm, -7mm), (10mm, 7mm), (0mm, 0mm))),
		move(dx: 99.3mm, dy: 7.8mm + 2cm, tri(dir: -calc.atan(10/7))),
		move(dx: 106mm, dy: 3.5mm + 2cm, [`0..f`]),

		// d0 -> o0
		move(dx: 4cm, dy: 5mm, path((2.5mm, 0mm), (2.5mm, 40mm), (20mm, 40mm))),
		move(dx: 6cm, dy: 45mm, tri()),
		move(dx: 49mm, dy: 4cm, [`o`]),
		// o0 -> o
		move(dx: 7cm, dy: 45mm, line(length: 2cm)),
		move(dx: 9cm, dy: 45mm, tri()),
		move(dx: 7.55cm, dy: 4cm, [`0..7`]),
		// o -> o
		move(dx: 9.5cm, dy: 5mm + 4cm, path((0mm, 0mm), (10mm, -7mm), (10mm, 7mm), (0mm, 0mm))),
		move(dx: 99.3mm, dy: 7.8mm + 4cm, tri(dir: -calc.atan(10/7))),
		move(dx: 106mm, dy: 3.5mm + 4cm, [`0..7`]),

		move(state[$q_0$]),
		move(dx: 3cm, a_state[$d_0$]),
		move(dx: 6cm, state[$b_0$]),
		move(dx: 6cm, dy: 2cm, state[$h_0$]),
		move(dx: 6cm, dy: 4cm, state[$o_0$]),
		move(dx: 9cm, a_state[$b$]),
		move(dx: 9cm, dy: 2cm, a_state[$h$]),
		move(dx: 9cm, dy: 4cm, a_state[$o$]),
		move(dy: 3cm, a_state[$d$]),
		move(dx: 3cm, dy: 4cm, a_state[$f$])
	)
}) <lex-nfa_gen-fig1>