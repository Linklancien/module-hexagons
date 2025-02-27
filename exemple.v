import	gg
import	hexa
const	bg_color = gg.Color{0, 0, 0, 255}

struct App {
	mut:
	ctx	&gg.Context	= unsafe { nil }

	// mouse
	mouse_x	f32
	mouse_y	f32
}


fn main() {
	mut app := &App{}
	app.ctx = gg.new_context(
		fullscreen: false
		width: 100*8
		height: 100*8
		create_window: true
		window_title: '- Hexagons -'
		user_data: app
		bg_color: bg_color
		init_fn:  on_init
		frame_fn: on_frame
		event_fn: on_event
		sample_count: 4
	)
	// map_test := [][][]int{len: 10, init: 
	// 	[][]int{len: 10, init:
	// 			if index == 0 || index == 9{[1]}else{[]}
	// 		}
	// }
	// println(hexa.ray_cast_hexa_x(5, 5, hexa.Direction_x.up_right, map_test, 10))
	// max := 10
	// mut errors	:= [0, 0, 0]
	// for x in 0..max+1{
	// 	for y in 0..max+1{
	// 		print("$x, $y : ")
	// 		avec_y := hexa.neighbors_hexa_y(x, y, max, max) // True one
	// 		avec_x := hexa.neighbors_hexa_y_by_x(x, y, max, max)
			
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
			
	// 		x, y := hexa.coo_hexa_x_to_ortho(xb, yb)
			
	// 		xr, yr := hexa.coo_ortho_to_hexa_x(x, y)
			
	// 		println("Difs: ${xb-xr}, ${yb-yr}")
	// 	}
	// }
	app.ctx.run()
}

fn on_init(mut app App){}

fn on_frame(mut app App){
	app.ctx.begin()
	r := 30.0

	coo_x, coo_y := hexa.coo_ortho_to_hexa_x(f32(app.mouse_x/r), f32(app.mouse_y/r))
	for x in 0..10{
		for y in 0..10{
			pos_x, pos_y := hexa.coo_hexa_x_to_ortho(x, y)
			
			mut c := gg.Color{125, 125, 125, 255}
			if x%2 == 0 && y%2 == 0{
				c = gg.Color{0, 0, 255, 255}
			}
			else if x%2 == 0 {
				c = gg.Color{255, 0, 122, 255}
			}
			else if y%2 == 0{
				c = gg.Color{255, 122, 0, 255}
			}
			else{
				c = gg.Color{0, 255, 0, 255}
			}

			if coo_x == x && coo_y == y{
				c = gg.Color{255, 255, 255, 255}
			}
			hexa.draw_hexagon_x(f32(pos_x*r), f32(pos_y*r), f32(r), c, app.ctx)
		}
	}

	// coo_x2, coo_y2 := hexa.coo_ortho_to_hexa_x(f32((app.ctx.width - app.mouse_x)/r), f32(app.mouse_y/r))
	// for x in 0..9{
	// 	for y in 0..20{
	// 		pos_x, pos_y := hexa.coo_hexa_y_to_ortho(x, y)
			
	// 		mut c := gg.Color{125, 125, 125, 255}
	// 		if x%2 == 0 && y%2 == 0{
	// 			c = gg.Color{0, 0, 255, 255}
	// 		}
	// 		else if x%2 == 0 {
	// 			c = gg.Color{255, 0, 122, 255}
	// 		}
	// 		else if y%2 == 0{
	// 			c = gg.Color{255, 122, 0, 255}
	// 		}
	// 		else{
	// 			c = gg.Color{0, 255, 0, 255}
	// 		}

	// 		if coo_x2 == x && coo_y2 == y{
	// 			c = gg.Color{255, 255, 255, 255}
	// 		}
	// 		app.ctx.draw_circle_filled(f32(app.ctx.width - pos_x*r), f32(pos_y*r), f32(r), c)
	// 	}
	// }
	app.ctx.end()
}

fn on_event(e &gg.Event, mut app App){
	// size
	size := app.ctx.window_size()
	app.ctx.width 		= size.width
	app.ctx.height 		= size.height
	// mouse coo
	app.mouse_x, app.mouse_y = e.mouse_x, e.mouse_y
}