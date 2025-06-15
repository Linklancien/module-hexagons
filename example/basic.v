import gg
import gx
import hexagons { Hexa_tile }

const bg_color = gg.Color{0, 0, 0, 255}

struct App {
mut:
	ctx &gg.Context = unsafe { nil }
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
	x, y := hexagons.coo_ortho_to_hexa_x(app.ctx.mouse_pos_x / r, app.ctx.mouse_pos_y / r,
		30, 30)
	path := hexagons.line_hexa_x(x, y, 30, 30, hexagons.Direction_x.down_right, 3)

	// up_left
	// up_right
	// left
	// right
	// down_left
	// down_right


	of_set_x := 0
	of_set_y := 0
	hexagons.draw_colored_map_x(app.ctx, of_set_x, of_set_y, r, world_map, path, u8(255))
	app.ctx.end()
}

fn on_event(e &gg.Event, mut app App) {
	// size
	size := app.ctx.window_size()
	app.ctx.width = size.width
	app.ctx.height = size.height
}
