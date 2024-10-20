/// feather ignore all

// GameMaker solution for camera system
// Author: Nathan Hunter, badwronggames@gmail.com

/// @function						cam_shake_base(_amp_x, _amp_y, _amp_angle, _freq_x, _freq_y, _freq_angle, _duration, _in, _out) constructor
/// @param {real}	 _amp_x			Size of the shake on the x-axis
/// @param {real}	 _amp_y			Size of the shake on the y-axis
/// @param {real}	 _amp_angle		Size of the shake on camera angle
/// @param {real}	 _freq_x		Speed of the shake on the x-axis
/// @param {real}	 _freq_y		Speed of the shake on the y-axis
/// @param {real}	 _freq_angle	Speed of the shake on camera angle
/// @param {integer} _duration		Duration of shake in milliseconds (or 0 for indefinite)
/// @param {real}	 _in			Amount of duration the shake will blend-in
/// @param {real}	 _out			Amount of duration the shake will blend-out
/// @description					Abstract camera shake struct
function cam_shake_base(_amp_x, _amp_y, _amp_angle, _freq_x, _freq_y, _freq_angle, _duration, _in, _out) constructor
{
	// Abstract camera shake implementation
	// DO NOT make this struct directly with 'new'. Instead use one of its
	// inherited structs like cam_shake_perlin() or cam_shake_sine()
	
	// Inherited structs MUST implement: 
	//		static calculate_shake = function(_shake_component, _time, _blend)
	
	// Shake values
	amp_x		= _amp_x;
	amp_y		= _amp_y;
	amp_angle   = _amp_angle;
	freq_x		= _freq_x;
	freq_y		= _freq_y;
	freq_angle  = _freq_angle;
	
	// Timing values
	var _t = current_time;
	duration	= _duration;
	blend_in	= _in * _duration;
	blend_out	= _out * _duration;
	time_start  = _t;
	time_finish = _t + duration;
	time_in		= _t + blend_in;
	time_out	= time_finish - blend_out;
	
	static update = function(_shake_component, _speed)
	{
		var _time = current_time;
		
		if (duration > 0 && _time > time_finish)
			return true;

		var _blend = 1;
		if (duration != 0)
		{
			if (_time < time_in)
				_blend = (_time - time_start) / blend_in;
			else if (_time > time_out)
				_blend = (time_finish - _time) / blend_out;
		}
		
		calculate_shake(_shake_component, _time, _speed, _blend);

		return false;
	}
		
	static reset = function()
	{
		var _t = current_time;
		time_start  = _t;
		time_finish = _t + duration;
		time_in		= _t + blend_in;
		time_out	= time_finish - blend_out;
	}
	
}

/// @function						cam_shake_perlin(_amp_x, _amp_y, _amp_angle, _freq_x, _freq_y, _freq_angle, _duration, _in, _out) constructor
/// @param {real}	 _amp_x			Size of the shake on the x-axis
/// @param {real}	 _amp_y			Size of the shake on the y-axis
/// @param {real}	 _amp_angle		Size of the shake on camera angle
/// @param {real}	 _freq_x		Speed of the shake on the x-axis
/// @param {real}	 _freq_y		Speed of the shake on the y-axis
/// @param {real}	 _freq_angle	Speed of the shake on camera angle
/// @param {integer} _duration		Duration of shake in milliseconds (or 0 for indefinite)
/// @param {real}	 _in			Amount of duration the shake will blend-in
/// @param {real}	 _out			Amount of duration the shake will blend-out
/// @description					Creates camera shake using Perlin Noise
function cam_shake_perlin(_amp_x, _amp_y, _amp_angle, _freq_x, _freq_y, _freq_angle, _duration, _in, _out) : 
	cam_shake_base(_amp_x, _amp_y, _amp_angle, _freq_x, _freq_y, _freq_angle, _duration, _in, _out) constructor
{
	// Sample positions
	pos_x       = irandom(C_PERLIN_NOISE_SIZE); 
	pos_y       = irandom(C_PERLIN_NOISE_SIZE); 
	pos_angle   = irandom(C_PERLIN_NOISE_SIZE);
	
	static calculate_shake = function(_shake_component, _time, _speed, _blend)
	{
		_time *= _speed;
		_shake_component.x	   += perlin_noise_2d(pos_x, freq_x * _time) * amp_x * _blend;
		_shake_component.y	   += perlin_noise_2d(pos_y, freq_y * _time) * amp_y * _blend;
		_shake_component.angle += perlin_noise_2d(pos_angle, freq_angle * _time) * amp_angle * _blend;	
	}
}

/// @function						cam_shake_sine(_amp_x, _amp_y, _amp_angle, _freq_x, _freq_y, _freq_angle, _duration, _in, _out) constructor
/// @param {real}	 _amp_x			Size of the shake on the x-axis
/// @param {real}	 _amp_y			Size of the shake on the y-axis
/// @param {real}	 _amp_angle		Size of the shake on camera angle
/// @param {real}	 _freq_x		Speed of the shake on the x-axis
/// @param {real}	 _freq_y		Speed of the shake on the y-axis
/// @param {real}	 _freq_angle	Speed of the shake on camera angle
/// @param {integer} _duration		Duration of shake in milliseconds (or 0 for indefinite)
/// @param {real}	 _in			Amount of duration the shake will blend-in
/// @param {real}	 _out			Amount of duration the shake will blend-out
/// @description					Creates camera shake using sinusoidal waves
function cam_shake_sine(_amp_x, _amp_y, _amp_angle, _freq_x, _freq_y, _freq_angle, _duration, _in, _out) :
	cam_shake_base(_amp_x, _amp_y, _amp_angle, _freq_x, _freq_y, _freq_angle, _duration, _in, _out) constructor
{	
	static calculate_shake = function(_shake_component, _time, _speed, _blend)
	{
		_time = (_time - time_start) * _speed;
		_shake_component.x	   += dsin(_time * freq_x) * amp_x * _blend;
		_shake_component.y	   += dsin(_time * freq_y) * amp_y * _blend;
		_shake_component.angle += dsin(_time * freq_angle) * amp_angle * _blend;	
	}
}

/// @function						cam_shake_curve(_curve_x, _curve_y, _curve_angle, _duration) constructor
/// @param {asset}   _curve_x		The animation curve which contains the shake_x channel (or noone for no x shake)
/// @param {asset}   _curve_y		The animation curve which contains the shake_y channel (or noone for no y shake)
/// @param {asset}   _curve_angle	The animation curve which contains the shake_angle channel (or noone for no angle shake)
/// @param {integer} _duration		Duration of shake in milliseconds
/// @param {bool}    _loop			Whether the shake should loop
/// @description					Creates camera shake using animation curves
function cam_shake_curve(_curve_x, _curve_y, _curve_angle, _duration, _loop) constructor
{	
	// You can use different animation curves for each channel or a single one, just ensure 
	// you name them correctly in the animation curve itself (shake_x, shake_y, shake_angle).
	// A single animation curve can only be linear, smooth, or bezier.  So, if you want
	// a different model for each channel split them up into different animation curves.
	
	time_start = current_time;
	time_end   = current_time + _duration;
	duration   = _duration;
	loop       = _loop;
	
	channel_x	  = (animcurve_exists(_curve_x) ? animcurve_get_channel(_curve_x, "shake_x") : noone);
	channel_y	  = (animcurve_exists(_curve_y) ? animcurve_get_channel(_curve_x, "shake_y") : noone);
	channel_angle = (animcurve_exists(_curve_angle) ? animcurve_get_channel(_curve_angle, "shake_angle") : noone);
	
	static update = function(_shake_component, _speed)
	{
		var _time = current_time;
		
		if (_time > time_end)
		{
			if (loop)
			{
				time_start = time_end;
				time_end   += duration;
			}
			else
				return true;
		}
		
		var _pos = (_time - time_start) / duration * _speed;
		
		_shake_component.x	   += (channel_x != noone ? animcurve_channel_evaluate(channel_x, _pos) : 0); 
		_shake_component.y	   += (channel_y != noone ? animcurve_channel_evaluate(channel_y, _pos) : 0); 
		_shake_component.angle += (channel_angle != noone ? animcurve_channel_evaluate(channel_angle, _pos) : 0); 
		
		return false;
	}
	
	static reset = function()
	{
		time_start = current_time;
		time_end   = current_time + duration;
	}
}

/// @function					cam_shake_sequence(_sequence) constructor
/// @param {asset} _sequence	The sequence to use
/// @description				Creates camera shake using a sequence
function cam_shake_sequence(_sequence) constructor
{
	// The sequence used should have a single sprite track that the shake will follow
	// Ensure to set a Colour Multiply for the whole sequence with zero alpha or
	// else the sequence will be seen.
	
	// !!! If using a looping sequence you need to manage when it is destroyed
	// by calling destroy() function in this struct.
	
	static _seq_layer = layer_create(0, "cam_shake_sequences");
	
	seq_id     = layer_sequence_create(_seq_layer, 0, 0, _sequence);
	seq_struct = layer_sequence_get_instance(seq_id);
	seq_layer  = _seq_layer;
		
	static update = function(_shake_component, _speed)
	{
		if (!layer_sequence_exists(seq_layer, seq_id))
			return true;
		
		if (layer_sequence_is_finished(seq_id))
		{
			layer_sequence_destroy(seq_id);
			return true;
		}
		
		layer_sequence_speedscale(seq_id, _speed);
		
		var _tracks = seq_struct.activeTracks;
		if (array_length(_tracks))
		{	
			var _t = _tracks[0]; 
			_shake_component.x	   += _t.posx;
			_shake_component.y     += _t.posy;
			_shake_component.angle += _t.rotation;
		}	
		
		return false;
	}
	
	static destroy = function()
	{
		// Useful if you create a looping sequence
		if (layer_sequence_exists(seq_layer, seq_id))
			layer_sequence_destroy(seq_id);
	}
}

/// @function						create_cam_shake_bounce(_direction, _amplitude, _duration, _bounces, _in, _out)
/// @param {real}    _direction		The direction of the bounce in the range 0 - 360
/// @param {real}    _amplitude		The amplitude of the bounce (can be negative which will flip the direction)
/// @param {integer} _duration		The duration in milliseconds for the bounce
/// @param {real}    _bounces		The number of bounces (can be decimal like 2.5 bounces)
/// @param {real}	 _in			Amount of duration the shake will blend-in
/// @param {real}	 _out			Amount of duration the shake will blend-out
/// @description					Creates a camera shake that bounces in a direction
function create_cam_shake_bounce(_direction, _amplitude, _duration, _bounces, _in, _out)
{
	// Returns a camera shake using sine that is given a specific frequency
	// so that the number of bounces occilate evenly over the duration given.
	
	var _cos  = -dcos(_direction),
		_sin  = dsin(_direction),
		_freq = (180 * _bounces) / _duration;

	return new cam_shake_sine(_cos * _amplitude, _sin * _amplitude, 0, _freq, _freq, 0, _duration, _in, _out);
}

/// @function cam_shake_component(_padding) constructor
/// @param {integer} _padding	Padding amount the camera system can use for padding around the room edges
/// @description				Camera shake component to be added to a camera system
function cam_shake_component(_padding = 32) constructor
{
	x = 0;
	y = 0;
	angle = 0;
	padding = _padding;
	shake_list = ds_list_create();
	
	static update = function(_speed)
	{						
		for (var _i = ds_list_size(shake_list) - 1; _i > -1; _i--)
		{
			// Update each camera shake and remove from list if it returns true
			if (shake_list[| _i].update(self, _speed))
				ds_list_delete(shake_list, _i);
		}
	}
	
	static clear = function()
	{
		x = 0;
		y = 0;
		angle = 0;
	}
	
	static add = function(_cam_shake) {	ds_list_add(shake_list, _cam_shake); }
	
	static stop = function() { ds_list_clear(shake_list); }
	
	static destroy = function()	{ ds_list_destroy(shake_list); }
}