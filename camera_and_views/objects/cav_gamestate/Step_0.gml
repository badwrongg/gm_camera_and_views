if (keyboard_check_pressed(vk_escape))
	game_end();
	
var _inc = keyboard_check_pressed(vk_add) - keyboard_check_pressed(vk_subtract),
	_wheel  = mouse_wheel_down() - mouse_wheel_up(),
	_cam0   = get_game_camera(0),
	_cam2   = get_game_camera(2);

if (_wheel != 0 && _cam0 != noone)
	_cam0.increment_zoom(0.5 * _wheel);
	
if (_cam2 != noone)
	_cam2.increment_angle(0.1);
	
if (_inc != 0)
	gui_increment_user_scale(_inc * 0.1);
	
if (keyboard_check_pressed(ord("F")))
	display_manager.window_toggle_fullscreen();
	
if (keyboard_check_pressed(ord("G")))
{
	with (display_manager)
	{
		use_aa_point_sample = !use_aa_point_sample;
		application_surface_draw_enable(!use_aa_point_sample);
	}
}