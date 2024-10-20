/// feather ignore all

// Camera library
// Author: Nathan Hunter, badwronggames@gmail.com

#macro VIEW_ZOOM_MIN	   0.1
#macro VIEW_ZOOM_MAX	   4
#macro VIEW_ZOOM_SPEED	   0.1
#macro VIEW_DEFAULT_WIDTH  3200
#macro VIEW_DEFAULT_HEIGHT 3200
#macro VIEW_MINIMUM_WIDTH  640 // Zoom will never allow for a smaller width
#macro VIEW_MINIMUM_HEIGHT 360 // Zoom will never allow for a smaller height
#macro VIEW_DEFAULT_FOLLOW_OBJECT entity_player

function game_camera_create(
	_viewport_index, 
	_view_width, 
	_view_height, 
	_viewport_xpos, 
	_viewport_ypos, 
	_viewport_xscale, 
	_viewport_yscale, 
	_follow_object) constructor
{
	
	#region Declarations
	
		// Viewport
		viewport_index   = _viewport_index;
		viewport_xpos    = _viewport_xpos;
		viewport_ypos    = _viewport_ypos;
		viewport_xscale  = _viewport_xscale;
		viewport_yscale  = _viewport_yscale;
		viewport_visible = true;

		// Camera
		id			  = camera_create();
		x			  = 0;			// x coordinate in the room of the camera view
		y			  = 0;			// y coordinate in the room of the camera view
		width         = 0;			// width of the camera view
		height        = 0;			// height of the camera view
		angle         = 0;			// angle of the camera view
		view_width    = _view_width;  // desired view width before aspect ratio correction
		view_height   = _view_height; // desired view height before aspect ratio correction
		zoom          = 1;
		zoom_to       = 1;
		zoom_min      = VIEW_ZOOM_MIN;
		zoom_max      = VIEW_ZOOM_MAX;
		zoom_speed    = VIEW_ZOOM_SPEED;
		zoom_clamp    = true;  // Clamps zoom to fit room
		cam_speed     = 1;
		cam_shake     = new cam_shake_component();
		clamp_to_room = true; // Clamps camera to room

		// Follow
		follow		  = noone;			// id of the followed instance
		follow_object = _follow_object; // object_index or id of the instance to follow
		follow_x	  = 0;
		follow_y	  = 0;
		follow_speed  = 0.04;
	
	#endregion
	
	#region Public
	
		// These functions are for use with any camera setup using this struct
			
		static set_follow = function(_object)
		{
			// Sets the follow object, or use the actual instance id if needed
		
			follow_object = _object; 
			follow = instance_nearest(x, y, _object);
		
			if (instance_exists(follow))
			{
				follow_x = follow.x;
				follow_y = follow.y;
			}
		}
	
		static set_position = function(_x, _y)
		{
			// Immediately sets the camera position.
			// If following an instance the camera will still go back to it
		
			x = _x;
			y = _y;
			follow_x = x;
			follow_y = y;
			update_view();
		}

		static set_view_size = function(_view_width, _view_height)
		{
			view_width  = _view_width;
			view_height = _view_height;
			update_aspect_and_zoom();
		}
		
		static set_viewport = function(_viewport_xpos, _viewport_ypos, _viewport_xscale, _viewport_yscale)
		{
			// Sets all the viewport properties
			
			var _back_buffer_scale = get_back_buffer_scale();
		
			viewport_xpos   = _viewport_xpos;
			viewport_ypos   = _viewport_ypos;
			viewport_xscale = _viewport_xscale;
			viewport_yscale = _viewport_yscale;
			update_viewport(window_get_width() * _back_buffer_scale, window_get_height() * _back_buffer_scale);
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
			angle = _angle;	
		}
	
		static increment_angle = function(_increment)
		{
			set_angle(angle + _increment);
		}
	
		static set_visible = function(_visible)
		{
			viewport_visible = _visible;
		
			var _back_buffer_scale = get_back_buffer_scale();
			update_viewport(window_get_width() * _back_buffer_scale, window_get_height() * _back_buffer_scale);
		}
	
		static get_visible = function()
		{
			return viewport_visible;	
		}
	
	#endregion
	
	#region Manual camera control
		
		// Only needed if not using the display_manager object
		
		static update = function()
		{
			// Called every step when updating the camera
		
			update_follow();
			cam_shake.update(cam_speed);
			zoom = lerp(zoom, zoom_to, 0.1);
			update_view();
			cam_shake.clear();
		}
	
		static room_start = function(_window_width, _window_height)
		{		
			// Call on room start or if the event already ran call on create of camera
		
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
		
			cam_shake.clear();
			update_view();
		}
		
		static update_viewport = function(_window_width, _window_height)
		{
			// Call when resizing the game window or changing viewport settings
		
			var _cam = view_get_camera(viewport_index);
			if (_cam != id)
				camera_destroy(_cam);
	
			view_set_visible(viewport_index, viewport_visible);
			view_set_camera(viewport_index, id);
			view_set_wport(viewport_index, _window_width  * viewport_xscale);
			view_set_hport(viewport_index, _window_height * viewport_yscale);
			view_set_xport(viewport_index, _window_width  * viewport_xpos);
			view_set_yport(viewport_index, _window_height * viewport_ypos);
			update_aspect_and_zoom();
		}
		
		static destroy_camera = function()
		{
			// Cameras usually persist for the entire game, but just in case it is needed...
			camera_destroy(id);
			cam_shake.destroy();
		}
		
		
	#endregion
	
	#region Private
	
		// Functions that you never would need to call directly
	
		static update_view = function()
		{
			// Sets the final view size and position
			
			var _width   = width  * zoom,
				_height  = height * zoom,
				_padding = cam_shake.padding;
				
			if (clamp_to_room)
			{
				x = clamp(follow_x - _width  * 0.5, _padding, room_width  - _width  - _padding);
				y = clamp(follow_y - _height * 0.5, _padding, room_height - _height - _padding);	
			}
			else
			{
				x = follow_x - _width  * 0.5;
				y = follow_y - _height * 0.5;
			}
	
			camera_set_view_size(id, _width, _height);
			camera_set_view_pos(id, x + cam_shake.x, y + cam_shake.y);
			camera_set_view_angle(id, angle + cam_shake.angle);
		}
	
		static update_follow = function()
		{
			// ** This could be edited to follow the object in different ways
			
			if (instance_exists(follow))
			{
				follow_x += (follow.x - follow_x) * follow_speed;
				follow_y += (follow.y - follow_y) * follow_speed;
				return;
			}
	
			follow = instance_nearest(x, y, follow_object);
		}
	
		static update_aspect_and_zoom = function()
		{
			// Scales the camera view aspect with the viewport is belongs to
			// Then sets the maximum zoom value to keep the view in the game room
		
			var _aspect_view = view_get_hport(viewport_index)/view_get_wport(viewport_index),
				_aspect_cam  = view_height/view_width;
		
			if (_aspect_view > _aspect_cam)
			{
				var _excess = view_height * (_aspect_view/_aspect_cam - 1);  
				height = view_height + _excess;
				width = view_width;
			}
			else
			{
				var _excess = view_width * (_aspect_cam/_aspect_view - 1);  
				width = view_width + _excess;
				height = view_height;
			}
			
			if (zoom_clamp)
			{
				var _padding = cam_shake.padding * 2;
				zoom_max = min(min(max(room_width - _padding, VIEW_MINIMUM_WIDTH)/width, max(room_height - _padding, VIEW_MINIMUM_HEIGHT)/height), VIEW_ZOOM_MAX);
			}
			
			zoom_to = clamp(zoom_to, zoom_min, zoom_max);
			zoom = zoom_to;
		}
	
	#endregion

}

#region Game Camera Array

	function get_game_camera_array()
	{
		// Static array of game_cameras
	
		static _game_cameras = array_create(0);
	
		return _game_cameras;
	}

	function add_game_camera(
		_viewport_index, 
		_view_width, 
		_view_height, 
		_viewport_xpos, 
		_viewport_ypos, 
		_viewport_xscale, 
		_viewport_yscale, 
		_follow_object)
	{
		// Adds a game_camera to the static game_camera array
		
		var _cam = new game_camera_create(
			_viewport_index, 
			_view_width, 
			_view_height, 
			_viewport_xpos, 
			_viewport_ypos, 
			_viewport_xscale, 
			_viewport_yscale, 
			_follow_object);
		array_push(get_game_camera_array(), _cam); 
	
		return _cam;
	}

	function get_game_camera(_index)
	{
		// Get a game_camera by index
	
		var _cams = get_game_camera_array();
	
		if (_index < array_length(_cams))
			return _cams[_index];
		return noone;
	}

#endregion
