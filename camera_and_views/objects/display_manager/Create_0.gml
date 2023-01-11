function window_toggle_fullscreen()
{
	window_fullscreen = !window_get_fullscreen();
	window_width  = -1;
	window_height = -1;
	window_resize();
}

function window_resize()
{	
	var _width  = window_get_width(),
		_height = window_get_height();
		
	// If window is minimized
	if (_width == 0 || _height == 0)
		return;

	if (_width != window_width || _height != window_height)
	{
		if (window_fullscreen)
		{
			var _width  = display_get_width(),
				_height = display_get_height();	
		
			window_set_fullscreen(true);
		}
		else
			window_set_fullscreen(false);
		
		var _display_scales    = get_display_scales(),
			_back_buffer_scale = _display_scales[e_display_scale.back_buffer],
			_render_scale      = _display_scales[e_display_scale.render];
		
		surface_resize(application_surface, _width * _render_scale, _height * _render_scale);	
		window_set_size(_width, _height);
		gui_on_window_resize(_width, _height);
		
		window_width  = _width;
		window_height = _height;
		
		// Back buffer can be smaller than actual window
		_width  *= _back_buffer_scale;
		_height *= _back_buffer_scale;
		
		// Only update viewports if room start ran already
		if (room_start_ran)
		{
			for (var _i = 0, _len = array_length(game_cameras); _i < _len; _i++)
				game_cameras[_i].update_viewport(_width, _height);
		}
		else
			window_room_start(_width, _height);

	}
	
	alarm[WINDOW_RESIZE] = 20;
}
	
function window_room_start(_window_width, _window_height)
{
	room_start_ran = true;
	view_enabled = true; // Enables all views in this room
	
	for (var _i = 0, _len = array_length(game_cameras); _i < _len; _i++)
		game_cameras[_i].room_start(_window_width, _window_height);
		
	var _layer = layer_get_id("asset_gui_guide");
	if (_layer != 1)
		layer_set_visible(_layer, false);
}

gpu_set_tex_filter(DISPLAY_DEFAULT_TEXTURE_FILTERING);
application_surface_draw_enable(!use_aa_point_sample);

game_cameras = get_game_camera_array();

// Set to -1 so the resize function always triggers
room_start_ran = false;
window_width   = -1;
window_height  = -1;
window_fullscreen = DISPLAY_DEFAULT_FULLSCREEN;
window_resize();

