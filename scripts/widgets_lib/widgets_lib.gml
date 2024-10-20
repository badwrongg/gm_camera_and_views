/// feather ignore all

// GUI widget library
// Author: Nathan Hunter, badwronggames@gmail.com

function get_widget_value_map()
{
	// This is a static map to store values that widgets such as
	// sliders, checkboxes, etc. are assigned.
 
	static _widget_value_map = ds_map_create();
	return _widget_value_map;
}

function widget_get_value(_key)
{
	// Get a widget value from a given key
	static _widget_value_map = get_widget_value_map();
	return _widget_value_map[? _key];
}

function widget_set_value(_key, _value)
{
	// Set a widget value to the given key
	static _widget_value_map = get_widget_value_map();
	_widget_value_map[? _key] = _value;
}

function widget_on_mouse_over(_x, _y)
{
	// Sets an alarm that acts as a boolean for mouse over
	// highlighting, etc.
	widget_mouse_over = true;
}

function widget_no_function(_x, _y) { return false; }

function widget_slider_set_value_position(_x, _y)
{
	value_pos = clamp(lerp_inverse(bbox_left, bbox_right, _x), 0, 1);
	var _value = lerp(value_min, value_max, value_pos);	
	value = (value_round ? round(_value) : _value);
	widget_set_value(value_key, value);
}

function widget_button_cam_shake_stop(_x, _y)
{
	image_speed = 1;
	get_game_camera(0).cam_shake.stop();
}

function widget_button_cam_shake_perlin(_x, _y)
{
	
	image_speed = 1;
	
	var _shake = new cam_shake_perlin(
		widget_get_value("shake_amp_x"), 
		widget_get_value("shake_amp_y"), 
		widget_get_value("shake_amp_angle"), 
		widget_get_value("shake_freq_x"), 
		widget_get_value("shake_freq_y"), 
		widget_get_value("shake_freq_angle"), 
		widget_get_value("shake_duration"), 
		widget_get_value("shake_blend_in"), 
		widget_get_value("shake_blend_out"));
		
	get_game_camera(0).cam_shake.add(_shake);
}

function widget_button_cam_shake_sine(_x, _y)
{
	
	image_speed = 1;
	
	var _shake = new cam_shake_sine(
		widget_get_value("shake_amp_x"), 
		widget_get_value("shake_amp_y"), 
		widget_get_value("shake_amp_angle"), 
		widget_get_value("shake_freq_x"), 
		widget_get_value("shake_freq_y"), 
		widget_get_value("shake_freq_angle"), 
		widget_get_value("shake_duration"), 
		widget_get_value("shake_blend_in"), 
		widget_get_value("shake_blend_out"));
		
	get_game_camera(0).cam_shake.add(_shake);
}

function widget_button_cam_shake_curves()
{
	image_speed = 1;
	
	var _shake = new cam_shake_curve(anim_shake0, anim_shake0, anim_shake0, widget_get_value("shake_duration"), false);
	get_game_camera(0).cam_shake.add(_shake);
}

function widget_button_cam_shake_sequence()
{
	image_speed = 1;
	
	var _shake = new cam_shake_sequence(seq_shake0);
	get_game_camera(0).cam_shake.add(_shake);
}

function widget_button_cam_shake_bounce()
{
		
	image_speed = 1;
	
	var _shake = create_cam_shake_bounce(
		widget_get_value("shake_direction"), 
		widget_get_value("shake_amp_x"), 
		widget_get_value("shake_duration"), 
		widget_get_value("shake_bounces"), 
		widget_get_value("shake_blend_in"), 
		widget_get_value("shake_blend_out"));
		
	get_game_camera(0).cam_shake.add(_shake);
}