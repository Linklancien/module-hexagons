import gg
import gx
import hexagons { Hexa_tile }

const bg_color = gg.Color{0, 0, 0, 255}

struct App {
mut:
	ctx &gg.Context = unsafe { nil }

	// mouse
	mouse_x f32
	mouse_y f32
}

struct Temp {
mut:
	color gx.Color = gx.Color{0, 255, 0, 255}
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

	app.ctx.run()
}

fn on_init(mut app App) {}

fn on_frame(mut app App) {
	app.ctx.begin()
	r := f32(30.0)
	mut world_map := [][][]Hexa_tile{len: 30, init: [][]Hexa_tile{len: 30, init: []Hexa_tile{len: 1, init: Hexa_tile(Temp{})}}}

	// hexagons.draw_colored_map_x(0, 0, r, world_map, gg.Color{100, 125, 0, 255}, app.ctx)
	x, y := hexagons.coo_ortho_to_hexa_x(app.mouse_x / r, app.mouse_y / r, 30, 30)
	of_set_x := 0
	of_set_y := 0
	hexagons.draw_debug_map_x(app.ctx, of_set_x, of_set_y, r, world_map, x - of_set_x,
		y - of_set_y)
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
