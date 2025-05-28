module hexagons

fn test_coo() {
	for x in 0 .. 10 {
		for y in 0 .. 10 {
			pos_x, pos_y := coo_hexa_x_to_ortho(x, y)
			new_x, new_y := coo_ortho_to_hexa_x(pos_x, pos_y, 10, 10)

			assert x == new_x, 'x != new_x'
			assert y == new_y, 'y != new_y'
		}
	}
}
