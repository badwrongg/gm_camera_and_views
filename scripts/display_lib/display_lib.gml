/// feather ignore all

// Display library
// Author: Nathan Hunter, badwronggames@gmail.com

#macro DISPLAY_DEFAULT_FULLSCREEN true
#macro DISPLAY_DEFAULT_TEXTURE_FILTERING true
#macro DISPLAY_DEFAULT_WINDOWED_WIDTH 800
#macro DISPLAY_DEFAULT_WINDOWED_HEIGHT 600

// These functions are mostly just used by the display_manager object

function get_display_scales()
{
	enum e_display_scale
	{
		back_buffer,
		render
	}
	
	static _display_scales = [1, 1];
	return _display_scales;
}

function get_back_buffer_scale()
{
	return get_display_scales()[e_display_scale.back_buffer];	
}

function get_render_scale()
{
	return get_display_scales()[e_display_scale.render];	
}

function set_back_buffer_scale(_scale)
{
	get_display_scales()[e_display_scale.back_buffer] = _scale;	
	
	var _cams   = get_game_camera_array(),
		_width  = window_get_width() * _scale,
		_height = window_get_height() * _scale;
	
	for (var _i = 0, _len = array_length(_cams); _i < _len; _i++)
		_cams[_i].update_viewport(_width, _height);
}

function set_render_scale(_scale)
{
	get_display_scales()[e_display_scale.render] = _scale;
	surface_resize(application_surface, window_get_width() * _scale, window_get_height() * _scale);	
}