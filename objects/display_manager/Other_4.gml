/// @description Game cameras room_start
/// feather ignore all

if (!room_start_ran)
{
	var _back_buffer_scale = get_back_buffer_scale();
	window_room_start(window_get_width() * _back_buffer_scale, window_get_height() * _back_buffer_scale);
}