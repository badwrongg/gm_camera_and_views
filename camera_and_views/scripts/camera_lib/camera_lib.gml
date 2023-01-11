#macro VIEW_ZOOM_MIN   0.1
#macro VIEW_ZOOM_MAX   4
#macro VIEW_ZOOM_SPEED 0.1
#macro VIEW_DEFAULT_WIDTH  3200
#macro VIEW_DEFAULT_HEIGHT 3200
#macro VIEW_DEFAULT_FOLLOW_OBJECT entity_player

function game_camera_create(
	_view_index, 
	_cam_width, 
	_cam_height, 
	_view_xpos, 
	_view_ypos, 
	_view_xscale, 
	_view_yscale, 
	_follow_object) constructor
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
		// Call this every step that the camera should update
		
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
		if (instance_exists(follow))
		{
			follow_x += (follow.x - follow_x) * follow_speed;
			follow_y += (follow.y - follow_y) * follow_speed;
			return;
		}
	
		follow = instance_nearest(x, y, follow_object);
	}
	
	static set_follow = function(_object)
	{
		follow_object = _object; // Could be instance id as well
		follow = instance_nearest(x, y, _object);
		
		if (instance_exists(follow))
		{
			follow_x = follow.x;
			follow_y = follow.y;
		}
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
	
	static set_angle = function (_angle)
	{
		camera_set_view_angle(id, _angle);	
	}
	
	static increment_angle = function(_increment)
	{
		set_angle(camera_get_view_angle(id) + _increment);
	}
	
	static update_viewport = function(_window_width, _window_height)
	{
		// Sets the properties of the viewport that this camera belongs to
		// Call when resizing the game window or changing viewport settings
		
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
		// Scales the camera view aspect with the viewport is belongs to
		// Then sets the maximum zoom value to keep the view in the game room
		
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

