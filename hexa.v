module hexagons

import gg

pub enum Direction_x {
	up_left
	up_right
	left
	right
	down_left
	down_right
}

pub enum Direction_y {
	left_up
	left_down
	up
	down
	right_up
	right_down
}

pub fn dir_y_to_x(dir_y Direction_y) Direction_x {
	mut dir_x := Direction_x.left
	match dir_y {
		.left_up { dir_x = Direction_x.up_left }
		.left_down { dir_x = Direction_x.down_right }
		.up { dir_x = Direction_x.left }
		.down { dir_x = Direction_x.right }
		.right_up { dir_x = Direction_x.up_right }
		.right_down { dir_x = Direction_x.down_right }
	}
	return dir_x
}

// tranfo de coo hexagonal en une position orthogonale
// lignes orizontales
pub fn coo_hexa_x_to_ortho(x int, y int) (f32, f32) {
	mut new_x := f32(x) * 1.73
	mut new_y := f32(int(y / 2)) * 3

	if y % 2 == 1 {
		new_x -= 0.866 // sqrt(3)/2
		new_y += 1.5
	}

	return new_x, new_y
}

pub fn coo_ortho_to_hexa_x(x f32, y f32) (int, int) {
	mut fx := int((x - 1) / 1.73)
	mut fy := int((y - 0.75) * 2 / 3)

	return fx, fy
}

pub fn test_coo_ortho_to_hexa_x(x f32, y f32) (int, int) {
	mut fx := int((x - 1) / 1.73)
	mut fy := int((y - 0.75) * 2 / 3)

	return fx, fy
}

// lignes verticales
pub fn coo_hexa_y_to_ortho(x int, y int) (f32, f32) {
	new_y, new_x := coo_hexa_x_to_ortho(y, x)
	return new_x, new_y
}

pub fn coo_ortho_to_hexa_y(x f32, y f32) (int, int) {
	new_y, new_x := coo_ortho_to_hexa_x(y, x)
	return new_x, new_y
}

// neighbors
// tous x
pub fn neighbors_hexa_x(x int, y int, max_x int, max_y int) [][]int {
	// max_x et max_y = len - 1
	mut neighbor := [][]int{}

	// y%2 = 1[[x-1, y]] [[x+1, y]] [[x, y-1]] [[x, y+1]]&& [[x-1, y-1]] [[x-1, y+1]]

	// y%2 = 0[[x-1, y]] [[x+1, y]] [[x, y-1]] [[x, y+1]]&& [[x+1, y-1]] [[x+1, y+1]]

	// both [[x-1, y]] [[x+1, y]] [[x, y-1]] [[x, y+1]]
	if x > 0 {
		neighbor << [[x - 1, y]]
		if y % 2 == 0 {
			if y > 0 {
				neighbor << [[x - 1, y - 1]]
			}
			if y < max_y {
				neighbor << [[x - 1, y + 1]]
			}
		}
	}
	if x < max_x {
		neighbor << [[x + 1, y]]
		if y % 2 == 1 {
			if y > 0 {
				neighbor << [[x + 1, y - 1]]
			}
			if y < max_y {
				neighbor << [[x + 1, y + 1]]
			}
		}
	}
	if y > 0 {
		neighbor << [[x, y - 1]]
	}
	if y < max_y {
		neighbor << [[x, y + 1]]
	}

	if neighbor.len == 0 {
		neighbor = [][]int{len: 1, init: []int{}}
	}
	return neighbor
}

// tous y
pub fn neighbors_hexa_y(x int, y int, max_x int, max_y int) [][]int {
	mut neighbor := [][]int{}

	if y > 0 {
		neighbor << [[x, y - 1]]
		if x % 2 == 1 {
			if x > 0 {
				neighbor << [[x - 1, y - 1]]
			}
			if x < max_y {
				neighbor << [[x + 1, y - 1]]
			}
		}
	}
	if y < max_y {
		neighbor << [[x, y + 1]]
		if x % 2 == 0 {
			if x > 0 {
				neighbor << [[x - 1, y + 1]]
			}
			if x < max_y {
				neighbor << [[x + 1, y + 1]]
			}
		}
	}
	if x > 0 {
		neighbor << [[x - 1, y]]
	}
	if x < max_x {
		neighbor << [[x + 1, y]]
	}

	if neighbor.len == 0 {
		neighbor = [][]int{len: 1, init: []int{}}
	}
	return neighbor
}

pub fn neighbors_hexa_y_by_x(x int, y int, max_x int, max_y int) [][]int {
	tempo_x := neighbors_hexa_x(y, x, max_y, max_x)
	mut avec_x := [][]int{}
	for t in tempo_x {
		avec_x << [t[1], t[0]]
	}
	return avec_x
}

// directionelle
// x
pub fn neighbor_hexa_x(x int, y int, max_x int, max_y int, dir Direction_x) [][]int {
	mut neighbor := [][]int{}
	match dir {
		.up_left {
			if x > 0 && y < max_y {
				if y % 2 == 0 {
					neighbor << [[x, y + 1]]
				} else {
					neighbor << [[x - 1, y + 1]]
				}
			}
		}
		.up_right {
			if x < max_x && y < max_y {
				if y % 2 == 0 {
					neighbor << [[x + 1, y + 1]]
				} else {
					neighbor << [[x, y + 1]]
				}
			}
		}
		.left {
			if x > 0 {
				neighbor << [[x - 1, y]]
			}
		}
		.right {
			if x < max_x {
				neighbor << [[x + 1, y]]
			}
		}
		.down_left {
			if x > 0 && y > 0 {
				if y % 2 == 0 {
					neighbor << [[x, y - 1]]
				} else {
					neighbor << [[x - 1, y - 1]]
				}
			}
		}
		.down_right {
			if x < max_x && y > 0 {
				if y % 2 == 0 {
					neighbor << [[x + 1, y - 1]]
				} else {
					neighbor << [[x, y - 1]]
				}
			}
		}
	}
	if neighbor.len == 0 {
		neighbor = [][]int{len: 1, init: []int{}}
	}
	return neighbor
}

// y
pub fn neighbor_hexa_y_by_x(x int, y int, max_x int, max_y int, dir Direction_y) [][]int {
	tempo_x := neighbor_hexa_x(y, x, max_y, max_x, dir_y_to_x(dir))
	mut avec_x := [][]int{}
	for t in tempo_x {
		avec_x << [t[1], t[0]]
	}
	return avec_x
}

// In a range
pub fn neighbor_hexa_x_in_range(x int, y int, max_x int, max_y int, dir Direction_x, range int) [][]int {
	mut neighbor := [][]int{}
	neighbor << prop_hexa_x(x, y, max_x, max_y, dir, range)
	if neighbor.len == 0 {
		neighbor = [][]int{len: 1, init: []int{}}
	}
	return neighbor
}

fn prop_hexa_x(x int, y int, max_x int, max_y int, dir Direction_x, n int) [][]int {
	mut neighbor := [][]int{}
	match dir {
		.left {
			if x > 0 {
				neighbor << [[x - 1, y]]
				neighbor << prop_hexa_x(x - 1, y, max_x, max_y, Direction_x.left, n - 1)
				if y % 2 == 0 {
					if y > 0 {
						neighbor << [[x - 1, y - 1]]
						line_hexa_x(x - 1, y - 1, max_x, max_y, Direction_x.left, n - 1)
					}
					if y < max_y {
						neighbor << [[x - 1, y + 1]]
						line_hexa_x(x - 1, y - 1, max_x, max_y, Direction_x.left, n - 1)
					}
				} else {
					if y > 0 {
						neighbor << [[x, y - 1]]
						line_hexa_x(x - 1, y - 1, max_x, max_y, Direction_x.left, n - 1)
					}
					if y < max_y {
						neighbor << [[x, y + 1]]
						line_hexa_x(x - 1, y - 1, max_x, max_y, Direction_x.left, n - 1)
					}
				}
			}
		}
		.right {
			if x < max_x {
				neighbor << [[x + 1, y]]
				neighbor << prop_hexa_x(x + 1, y, max_x, max_y, Direction_x.right, n - 1)
				if y % 2 == 0 {
					if y > 0 {
						neighbor << [[x + 1, y - 1]]
					}
					if y < max_y {
						neighbor << [[x + 1, y + 1]]
					}
				}
			}
		}
		else {}
	}

	return neighbor
}

pub fn line_hexa_x(x int, y int, max_x int, max_y int, dir Direction_x, n int) [][]int {
	mut neighbor := [][]int{}
	neighbor << neighbor_hexa_x(x, y, max_x, max_y, dir)
	if n > 1 {
		neighbor << line_hexa_x(neighbor[0][0], neighbor[0][1], max_x, max_y, dir, n - 1)
	}
	return neighbor
}

// Raycasting
pub fn ray_cast_hexa_x(x int, y int, dir Direction_x, world_map [][][]int, max_view int, min int) (int, int, int) {
	// x, y is the point from where the ray is emit
	mut pos_x := y
	mut pos_y := x
	max_x := world_map.len
	max_y := world_map[0].len
	mut dist := 0
	mut condition := true
	for condition {
		hex_tile := neighbor_hexa_x(pos_x, max_x, pos_y, max_y, dir)

		if hex_tile[0].len != 0 {
			pos_x = hex_tile[0][0]
			pos_y = hex_tile[0][1]
			dist += 1

			if world_map[pos_x][pos_y].len > 0 {
				condition = false
			} else if dist >= max_view {
				print('Out of view')
				condition = false
			}
		} else {
			// Used when the border is reach
			condition = false
			print('Breaked')
			break
		}
	}

	return pos_x, pos_y, dist
}

pub fn ray_cast_hexa_y_by_x(x int, y int, dir Direction_y, world_map [][][]int, max_view int, min int) (int, int, int) {
	new_y, new_x, dist := ray_cast_hexa_x(y, x, dir_y_to_x(dir), world_map, max_view,
		min)
	return new_x, new_y, dist
}

// Drawings
// Solos
pub fn draw_hexagon(x f32, y f32, size f32, rota f32, color gg.Color, ctx gg.Context) {
	ctx.draw_polygon_filled(x, y, size, 6, rota, color)
}

pub fn draw_hexagon_x(x f32, y f32, size f32, color gg.Color, ctx gg.Context) {
	draw_hexagon(x, y, size, 30, color, ctx)
}

pub fn draw_hexagon_y(x f32, y f32, size f32, color gg.Color, ctx gg.Context) {
	draw_hexagon(x, y, size, 60, color, ctx)
}

// Whole map
// debug:
pub fn draw_debug_map_x(dec_x int, dec_y int, r f32, world_map [][][]int, ctx gg.Context, coo_x int, coo_y int) {
	for x in 0 .. world_map.len {
		for y in 0 .. world_map[x].len {
			pos_x, pos_y := coo_hexa_x_to_ortho(x, y)

			mut c := gg.Color{125, 125, 125, 255}
			if x == 0 && y == 0 {
				c = gg.Color{125, 125, 125, 255}
			} else if x % 2 == 0 && y % 2 == 0 {
				c = gg.Color{0, 0, 255, 255}
			} else if x % 2 == 0 {
				c = gg.Color{255, 0, 122, 255}
			} else if y % 2 == 0 {
				c = gg.Color{255, 122, 0, 255}
			} else {
				c = gg.Color{0, 255, 0, 255}
			}

			if coo_x == x && coo_y == y {
				c = gg.Color{255, 255, 255, 255}
			}
			draw_hexagon_x(f32((pos_x + 1.5) * r), f32((pos_y + 1) * r), f32(r), c, ctx)
		}
	}
}

pub fn draw_debug_map_y(dec_x int, dec_y int, r f32, world_map [][][]int, ctx gg.Context, coo_x int, coo_y int) {
	for x in 0 .. world_map.len {
		for y in 0 .. world_map[x].len {
			pos_x, pos_y := coo_hexa_y_to_ortho(x, y)

			mut c := gg.Color{125, 125, 125, 255}
			if x == 0 && y == 0 {
				c = gg.Color{125, 125, 125, 255}
			} else if x % 2 == 0 && y % 2 == 0 {
				c = gg.Color{0, 0, 255, 255}
			} else if x % 2 == 0 {
				c = gg.Color{255, 0, 122, 255}
			} else if y % 2 == 0 {
				c = gg.Color{255, 122, 0, 255}
			} else {
				c = gg.Color{0, 255, 0, 255}
			}

			if coo_x == x && coo_y == y {
				c = gg.Color{255, 255, 255, 255}
			}
			draw_hexagon_y(f32((pos_x + 1) * r), f32((pos_y + 1.5) * r), f32(r), c, ctx)
		}
	}
}

pub fn draw_colored_map_x(dec_x int, dec_y int, r f32, world_map [][][]int, color gg.Color, ctx gg.Context) {
	for x in 0 .. world_map.len {
		for y in 0 .. world_map[x].len {
			pos_x, pos_y := coo_hexa_y_to_ortho(x, y)

			draw_hexagon_y(f32((pos_x + 1) * r), f32((pos_y + 1.5) * r), f32(r - 3), color,
				ctx)
		}
	}
}
