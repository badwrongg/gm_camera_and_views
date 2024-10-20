/// feather ignore all

// GUI library
// Author: Nathan Hunter, badwronggames@gmail.com

#macro GUI_DEFAULT_WIDTH  sprite_get_width(spr_gui_guide)
#macro GUI_DEFAULT_HEIGHT sprite_get_height(spr_gui_guide)

function gui_mouse_x()
{
	// Useful for using collision functions with GUI objects
	return window_mouse_get_x() / window_get_width() * display_get_gui_width();
}

function gui_mouse_y()
{
	// Useful for using collision functions with GUI objects
	return window_mouse_get_y() / window_get_height() * display_get_gui_height();
}

function get_gui_dimensions()
{
	enum e_gui_dimension
	{
		width,
		height,
		scale,
		window_scale,
		user_scale
	}
	
	static _gui_dimensions = [GUI_DEFAULT_WIDTH, GUI_DEFAULT_HEIGHT, 1, 1, 1];
		
	return _gui_dimensions;
}

function gui_on_window_resize(_window_width, _window_height)
{
	var _gui_width     = GUI_DEFAULT_WIDTH,
		_gui_height    = GUI_DEFAULT_HEIGHT,
		_aspect_window = _window_height/_window_width,
		_aspect_gui    = _gui_height/_gui_width;
		
	if (_aspect_window > _aspect_gui)
		_gui_height *= (_aspect_window/_aspect_gui);
	else
		_gui_width  *= (_aspect_gui/_aspect_window);
				
	display_set_gui_size(_gui_width, _gui_height);
	
	var _gd     = get_gui_dimensions(),
		_wscale = min(GUI_DEFAULT_WIDTH / _window_width, GUI_DEFAULT_HEIGHT / _window_height),
		_scale  = _gd[e_gui_dimension.user_scale] * _wscale;
		
	_gd[e_gui_dimension.width]  = _gui_width;
	_gd[e_gui_dimension.height] = _gui_height;
	_gd[e_gui_dimension.scale]  = _scale;
	_gd[e_gui_dimension.window_scale] = _wscale;
		
	with (__gui)
		gui_object_reposition(_gui_width, _gui_height, _scale);	
}

function gui_set_user_scale(_user_scale)
{
	_user_scale = clamp(_user_scale, 0.01, 10000);
	
	var _gd         = get_gui_dimensions(),
		_scale      = _user_scale * _gd[e_gui_dimension.window_scale],
		_gui_width  = _gd[e_gui_dimension.width],
		_gui_height = _gd[e_gui_dimension.height];
	
	_gd[e_gui_dimension.scale] = _scale;
	_gd[e_gui_dimension.user_scale] = _user_scale;
	
	with (__gui)
		gui_object_reposition(_gui_width, _gui_height, _scale);	
}

function gui_increment_user_scale(_increment)
{
	var _gd = get_gui_dimensions(),
		_user_scale = clamp(_gd[e_gui_dimension.user_scale] + _increment, 0.01, 10000),
		_scale = _user_scale * _gd[e_gui_dimension.window_scale],
		_gui_width = _gd[e_gui_dimension.width],
		_gui_height = _gd[e_gui_dimension.height];
	
	_gd[e_gui_dimension.scale] = _scale;
	_gd[e_gui_dimension.user_scale] = _user_scale;
	
	with (__gui)
		gui_object_reposition(_gui_width, _gui_height, _scale);		
}

function gui_object_reposition(_gui_width, _gui_height, _gui_scale)
{
	if (scale_with_gui)
	{
		image_xscale = image_xscalestart * _gui_scale;
		image_yscale = image_yscalestart * _gui_scale;
	}
	
	anchor_x(_gui_width);
	anchor_y(_gui_height);
	keep_on_screen(_gui_width, _gui_height);	
}

function gui_keep_on_screen(_gui_width, _gui_height)
{
	x = clamp(x, sprite_xoffset, _gui_width - (sprite_width - sprite_xoffset));
	y = clamp(y, sprite_yoffset, _gui_height - (sprite_height - sprite_yoffset));	
}

function gui_position_left( _gui_width)  { x = xstart; }
function gui_position_center(_gui_width) { x = _gui_width * 0.5 - (GUI_DEFAULT_WIDTH * 0.5 - xstart); }
function gui_position_right(_gui_width)  { x = _gui_width - (GUI_DEFAULT_WIDTH - xstart); }

function gui_position_top(_gui_height)    { y = ystart; }
function gui_position_middle(_gui_height) { y = _gui_height * 0.5 - (GUI_DEFAULT_HEIGHT * 0.5 - ystart); }
function gui_position_bottom(_gui_height) { y = _gui_height - (GUI_DEFAULT_HEIGHT - ystart); }
