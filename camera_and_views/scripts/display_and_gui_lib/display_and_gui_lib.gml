// View and resolutions
#macro VIEW_ZOOM_MIN   0.1
#macro VIEW_ZOOM_MAX   4
#macro VIEW_ZOOM_SPEED 0.1
#macro VIEW_DEFAULT_WIDTH  3200
#macro VIEW_DEFAULT_HEIGHT 3200
#macro VIEW_DEFAULT_FOLLOW_OBJECT entity_player

#macro GUI_DEFAULT_WIDTH  sprite_get_width(spr_gui_guide)
#macro GUI_DEFAULT_HEIGHT sprite_get_height(spr_gui_guide)

#macro DISPLAY_DEFAULT_FULLSCREEN true
#macro DISPLAY_DEFAULT_TEXTURE_FILTERING true

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

function get_game_camera_array()
{
	static _game_cameras = array_create(0);
	
	return _game_cameras;
}

function add_game_camera(_view_index, _cam_width, _cam_height, _view_xpos, _view_ypos, _view_xscale, _view_yscale, _follow_object)
{
	var _cam = new game_camera_create(_view_index, _cam_width, _cam_height, _view_xpos, _view_ypos, _view_xscale, _view_yscale, _follow_object);
	array_push(get_game_camera_array(), _cam); 
	
	return _cam;
}

function get_game_camera(_index)
{
	var _cams = get_game_camera_array();
	
	if (_index < array_length(_cams))
		return _cams[_index];
	return noone;
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
		reposition_gui_object(_gui_width, _gui_height, _scale);	
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
		reposition_gui_object(_gui_width, _gui_height, _scale);	
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
		reposition_gui_object(_gui_width, _gui_height, _scale);		
}

function reposition_gui_object(_gui_width, _gui_height, _gui_scale)
{
	
	if (scale_with_gui)
	{
		image_xscale = image_xscalestart * _gui_scale;
		image_yscale = image_yscalestart * _gui_scale;
	}
	
	anchor_x(_gui_width);
	anchor_y(_gui_height);
		
	var _width = (bbox_right - bbox_left) * 0.5,
		_height = (bbox_bottom - bbox_top) * 0.5;
				
	x = clamp(x, _width, _gui_width - _width);
	y = clamp(y, _height, _gui_height - _height);
	
}

function gui_position_left( _gui_width)  { x = xstart; }
function gui_position_center(_gui_width) { x = _gui_width * 0.5 - (GUI_DEFAULT_WIDTH * 0.5 - xstart); }
function gui_position_right(_gui_width)  { x = _gui_width - (GUI_DEFAULT_WIDTH - xstart); }

function gui_position_top(_gui_height)    { y = ystart; }
function gui_position_middle(_gui_height) { y = _gui_height * 0.5 - (GUI_DEFAULT_HEIGHT * 0.5 - ystart); }
function gui_position_bottom(_gui_height) { y = _gui_height - (GUI_DEFAULT_HEIGHT - ystart); }


function draw_app_surface_aa_point_sampling()
{
	static _u_texel_size = shader_get_uniform(shd_aa_point_sampling_glsl_es, "u_texel_size");
	static _u_pixel_scale = shader_get_uniform(shd_aa_point_sampling_glsl_es, "u_pixel_scale");

	var _tex_filter = gpu_get_tex_filter(),
		_window_width = window_get_width(),
		_window_height = window_get_height(),
		_surf_w = surface_get_width(application_surface),
		_surf_h = surface_get_height(application_surface),
		_tex = surface_get_texture(application_surface),
		_tex_w = texture_get_texel_width(_tex),
		_tex_h = texture_get_texel_height(_tex);

	shader_set(shd_aa_point_sampling_glsl_es);
	gpu_set_tex_filter(true);
	shader_set_uniform_f(_u_texel_size, _tex_w, _tex_h);
	shader_set_uniform_f(_u_pixel_scale, _window_width/_surf_w, _window_height/_surf_h);
	draw_surface_stretched(application_surface, 0, 0, _window_width, _window_height);
	shader_reset();
	gpu_set_tex_filter(_tex_filter);
}

function game_camera_create(_view_index, _cam_width, _cam_height, _view_xpos, _view_ypos, _view_xscale, _view_yscale, _follow_object) constructor
{
	// Viewport
	view_index  = _view_index;
	view_xpos   = _view_xpos;
	view_ypos   = _view_ypos;
	view_xscale = _view_xscale;
	view_yscale = _view_yscale;

	// Camera
	id = camera_create();
	x  = 0;
	y  = 0;
	cam_width   = _cam_width;
	cam_height  = _cam_height;
	width       = 0;
	height      = 0;
	zoom        = 1;
	zoom_to     = 1;
	zoom_min    = VIEW_ZOOM_MIN;
	zoom_max    = VIEW_ZOOM_MAX;
	zoom_speed  = VIEW_ZOOM_SPEED;

	// Follow
	follow		  = noone;
	follow_object = _follow_object;
	follow_x	  = 0;
	follow_y	  = 0;
	follow_speed  = 0.04;
	
	static update = function()
	{
		update_follow();
		zoom = lerp(zoom, zoom_to, 0.1);
		update_camera();
	}
	
	static update_camera = function()
	{
		var _width  = width  * zoom,
			_height = height * zoom;
				
		x = clamp(follow_x - _width  * 0.5, 0, room_width  - _width);
		y = clamp(follow_y - _height * 0.5, 0, room_height - _height);	
	
		camera_set_view_size(id, _width, _height);
		camera_set_view_pos(id, x, y);		
	}
	
	static update_follow = function()
	{
		if instance_exists(follow)
		{
			follow_x += (follow.x - follow_x) * follow_speed;
			follow_y += (follow.y - follow_y) * follow_speed;
			return;
		}
	
		follow = instance_nearest(x, y, follow_object);
	}
	
	static room_start = function(_window_width, _window_height)
	{		
		update_viewport(_window_width, _window_height);
		zoom_to = clamp(1, zoom_min, zoom_max);
		zoom    = zoom_to;
		
		follow = instance_nearest(x, y, follow_object);
		if instance_exists(follow)
		{
			follow_x = follow.x;
			follow_y = follow.y;
		}
		else
		{
			// If nothing to follow use the room center
			follow_x = room_width  * 0.5;
			follow_y = room_height * 0.5;		
		}
		
		update_camera();
	}
			
	static set_position = function(_x, _y)
	{
		x = _x;
		y = _y;
		update_camera();
	}

	static increment_zoom = function(_increment)
	{
		zoom_to = clamp(zoom_to + _increment * zoom_speed, zoom_min, zoom_max);
	}

	static set_zoom = function(_zoom)
	{	
		zoom_to = clamp(_zoom, zoom_min, zoom_max);
	}	
	
	static update_viewport = function(_window_width, _window_height)
	{
		var _cam = view_get_camera(view_index);
		if (_cam != id)
			camera_destroy(_cam);
	
		view_set_visible(view_index, true);
		view_set_camera(view_index, id);
		
		var _vwidth  = _window_width * view_xscale,
			_vheight = _window_height * view_yscale;
	
		view_set_wport(view_index, _vwidth);
		view_set_hport(view_index, _vheight);
		view_set_xport(view_index, min(_window_width * view_xpos, _window_width - _vwidth * 0.5));
		view_set_yport(view_index, min(_window_height * view_ypos, _window_height - _vheight * 0.5));
		update_aspect_and_zoom();
	}
	
	static update_aspect_and_zoom = function()
	{
		var _aspect_view = view_get_hport(view_index)/view_get_wport(view_index),
			_aspect_cam  = cam_height/cam_height;
		
		if (_aspect_view > _aspect_cam)
		{
			var _excess = cam_height * (_aspect_view/_aspect_cam - 1);  
			height = cam_height + _excess;
			width = cam_width;
		}
		else
		{
			var _excess = cam_width * (_aspect_cam/_aspect_view - 1);  
			width = cam_width + _excess;
			height = cam_height;
		}
	
		zoom_max = min(min(room_width/width, room_height/height), VIEW_ZOOM_MAX);
	}
	
	static set_camera_size = function(_width, _height)
	{
		cam_width  = _width;
		cam_height = _height;
		update_aspect_and_zoom();
	}
	
	static set_viewport = function(_xpos, _ypos, _xscale, _yscale)
	{
		var _back_buffer_scale = get_back_buffer_scale();
		
		view_xpos   = _xpos;
		view_ypos   = _ypos;
		view_xscale = _xscale;
		view_yscale = _yscale;
		update_viewport(window_get_width() * _back_buffer_scale, window_get_height() * _back_buffer_scale);
	}
	
}