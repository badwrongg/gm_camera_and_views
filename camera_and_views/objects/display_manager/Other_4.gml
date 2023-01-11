if (!room_start_ran)
{
	var _display_scales    = get_display_scales(),
		_back_buffer_scale = _display_scales[e_display_scale.back_buffer];
		
	window_room_start(window_get_width() * _back_buffer_scale, window_get_height() * _back_buffer_scale);
}