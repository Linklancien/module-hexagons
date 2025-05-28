import gg
import hexagons

const bg_color = gg.Color{0, 0, 0, 255}

struct App {
mut:
	ctx &gg.Context = unsafe { nil }

	// mouse
	mouse_x f32
	mouse_y f32
}

fn main() {
	mut app := &App{}
	app.ctx = gg.new_context(
		fullscreen:    false
		width:         100 * 8
		height:        100 * 8
		create_window: true
		window_title:  '- Hexagons -'
		user_data:     app
		bg_color:      bg_color
		init_fn:       on_init
		frame_fn:      on_frame
		event_fn:      on_event
		sample_count:  4
	)

	// println("${hexagons.line_hexa_x(0, 0, 10, 10, hexagons.Direction_x.up_right, 10)}")
	// map_test := [][][]int{len: 10, init:
	// 	[][]int{len: 10, init:
	// 			if index == 0 || index == 9{[1]}else{[]}
	// 		}
	// }
	// println(hexagons.ray_cast_hexa_x(5, 5, hexagons.Direction_x.up_right, map_test, 10, 1))
	// max := 10
	// mut errors	:= [0, 0, 0]
	// for x in 0..max+1{
	// 	for y in 0..max+1{
	// 		print("$x, $y : ")
	// 		avec_y := hexagons.neighbors_hexa_y(x, y, max, max) // True one
	// 		avec_x := hexagons.neighbors_hexa_y_by_x(x, y, max, max)
	// 		print("$avec_y |")
	// 		print("$avec_x ")
	// 		if avec_x.len != avec_y.len{
	// 			// print("Not as many")
	// 			errors[0] += 1
	// 		}
	// 		else{
	// 			for i in 0..avec_x.len{
	// 				if avec_x[i] == avec_y[i]{
	// 					// print("GOOD ")
	// 					errors[1] += 1
	// 				}
	// 				else{
	// 					print("[${avec_x[i][0] - avec_y[i][0]}, ${avec_x[i][1] - avec_y[i][1]}] ")
	// 					errors[2] += 1
	// 				}
	// 			}
	// 		}
	// 		println("")
	// 	}
	// }
	// print("Not ${errors[0]}, GOOD ${errors[1]}, Difs ${errors[2]}")
	// Not 32, GOOD 134, Difs 260	x et y a leurs places dans _x
	// Not 0, GOOD 18, Difs 504		x et y inversé dans _x
	// max := 10
	// for xb in 0..max{
	// 	for yb in 0..max{

	// 		x, y := hexagons.coo_hexa_x_to_ortho(xb, yb)

	// 		xr, yr := hexagons.coo_ortho_to_hexa_x(x, y)

	// 		println("Difs: ${xb-xr}, ${yb-yr}")
	// 	}
	// }
	app.ctx.run()
}

fn on_init(mut app App) {}

fn on_frame(mut app App) {
	app.ctx.begin()
	r := f32(30.0)
	world_map := [][][]int{len: 30, init: [][]int{len: 30, init: []int{len: 10, init: 10}}}

	// hexagons.draw_colored_map_x(0, 0, r, world_map, gg.Color{100, 125, 0, 255}, app.ctx)
	x, y := hexagons.coo_ortho_to_hexa_x(app.mouse_x / r, app.mouse_y / r, 30, 30)
	println('This: x: ${x} y: ${y}')
	hexagons.draw_debug_map_x(0, 0, r, world_map, app.ctx, x, y)
	app.ctx.end()
}

fn on_event(e &gg.Event, mut app App) {
	// size
	size := app.ctx.window_size()
	app.ctx.width = size.width
	app.ctx.height = size.height

	// mouse coo
	app.mouse_x, app.mouse_y = e.mouse_x, e.mouse_y
}
