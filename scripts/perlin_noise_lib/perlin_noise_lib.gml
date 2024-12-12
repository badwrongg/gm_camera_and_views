/// feather ignore all

// GameMaker solution for Perlin Noise
// Author: Nathan Hunter, badwronggames@gmail.com
// URL for full setup and information: https://pastebin.com/drwkYhUt

#macro C_PERLIN_NOISE_SIZE 1024
#macro C_PERLIN_NOISE_SIZE_MASK 1023
#macro C_PERLIN_NOISE_BUFFER_SIZE 1048576
#macro C_PERLIN_NOISE_BUFFER_MASK 1048575

/// @function					perlin_noise(_offset, _rate)
/// @param {integer} _offset	A fixed positive offset into the buffer (use a constant)
/// @param {real} _rate			Rate of sample over time (used with current_time)
/// @description				Returns perlin noise value from -1 to 1 using premade buffer using offset and rate
function perlin_noise(_offset, _rate)
{	
	// This is a solid way to sample from perlin noise.  It uses time and an offset value which
	// makes each next sample close the previous based on how small the _rate argument is.
	// The _offset argument should be a constant which does not change, and it's purpose is
	// so that different objects, animations, or whatever sample from different places (but still over time)
	
	static _perlin_noise_buffer = get_perlin_noise_buffer();
	var _value = buffer_peek(_perlin_noise_buffer, (floor(_offset + current_time * _rate) & C_PERLIN_NOISE_BUFFER_MASK) << 2, buffer_f32);
	return (_value - 0.5) * 2.0;
}

/// @function					perlin_noise_irange(_value1, _value2, _offset, _rate)
/// @param {integer} _value1    The first value
/// @param {integer} _value2	The second value
/// @param {integer} _offset	A fixed positive offset into the buffer (use a constant)
/// @param {real} _rate			Rate of sample over time (used with current_time)
/// @description				Returns an integer value between the two values using perlin noise
function perlin_noise_irange(_value1, _value2, _offset, _rate)
{	
	static _perlin_noise_buffer = get_perlin_noise_buffer();
	var _pos = buffer_peek(_perlin_noise_buffer, (floor(_offset + current_time * _rate) & C_PERLIN_NOISE_BUFFER_MASK) << 2, buffer_f32);
	return round(lerp(_value1, _value2, _pos));
}

/// @function					perlin_noise_range(_value1, _value2, _offset, _rate)
/// @param {real} _value1		The first value
/// @param {real} _value2		The second value
/// @param {integer} _offset	A fixed positive offset into the buffer (use a constant)
/// @param {real} _rate			Rate of sample over time (used with current_time)
/// @description				Returns a real value between the two values using perlin noise
function perlin_noise_range(_value1, _value2, _offset, _rate)
{	
	static _perlin_noise_buffer = get_perlin_noise_buffer();
	var _pos = buffer_peek(_perlin_noise_buffer, (floor(_offset + current_time * _rate) & C_PERLIN_NOISE_BUFFER_MASK) << 2, buffer_f32);
	return lerp(_value1, _value2, _pos);
}

/// @function			perlin_noise_2d(_x, _y)
/// @param {real} _x	The x coordinate to sample from (unbound range)
/// @param {real} _y	The y coordinate to sample from (unbound range)
/// @description		Samples perlin noise value from -1 to 1 using premade buffer using 2D coordinates
function perlin_noise_2d(_x, _y)
{
	// This function is when you want to really specify where to sample from the buffer,
	// and is rarely used over the normal perlin_noise() function
	
	static _perlin_noise_buffer = get_perlin_noise_buffer();
	_x = floor(_x) & C_PERLIN_NOISE_SIZE_MASK;
	_y = floor(_y) & C_PERLIN_NOISE_SIZE_MASK;
	var _value = buffer_peek(_perlin_noise_buffer, (_x + _y * C_PERLIN_NOISE_SIZE) << 2, buffer_f32);
	return (_value - 0.5) * 2.0;
}

function draw_perlin_noise_buffer(_x, _y)
{
	// *** DEBUG ONLY ***
	// Extremely slow function used to visualize the perlin noise buffer
	// Draw it to a surface once or frame rate will die
	
	var _buff = get_perlin_noise_buffer(),
		_dx = _x, 
		_dy = _y, 
		_val = 0, 
		_col = 0;

	for (var _c = 0; _c < C_PERLIN_NOISE_SIZE; _c++)
	{
		_dy = _y;
	
		for (var _r = 0; _r < C_PERLIN_NOISE_SIZE; _r++)
		{
			_val = buffer_peek(_buff, (_c + _r * C_PERLIN_NOISE_SIZE) << 2, buffer_f32) * 255;
			_col = make_color_rgb(_val, _val, _val);
			draw_rectangle_color(_dx, _dy, _dx + 1, _dy + 1, _col, _col, _col, _col, false);
		
			_dy++;
		}
		_dx++;
	}	
}

function shader_set_perlin_noise(_seed_value = 0, _frequency_min = 0.11111, _frequency_max = 0.99999)
{
	// Draws anything with a perlin noise texture
	// Will repeat if the UVs are the full 0 - 1 on the quad
	// Mainly just used for the private functions which create the buffer
	
	static _u_seed  = shader_get_uniform(shd_perlin_noise_glsl_es, "u_seed");
	static _u_table = shader_get_uniform(shd_perlin_noise_glsl_es, "u_table");
	static _table   = create_perlin_hash_table();
	static _seed    = random_range(25.11111, 29.99999);

	if (_seed_value != 0)
		_seed = _seed_value + random_range(_frequency_min, _frequency_max);

	shader_set(shd_perlin_noise_glsl_es);
	shader_set_uniform_f(_u_seed, _seed);
	shader_set_uniform_i_array(_u_table, _table);
}

#region Private Functions

	function get_perlin_noise_buffer()
	{
		static _perlin_noise_buffer = create_perlin_noise_buffer();
		return _perlin_noise_buffer;
	}

	function create_perlin_noise_buffer()
	{	
		var _surf  = surface_create(C_PERLIN_NOISE_SIZE, C_PERLIN_NOISE_SIZE),
			_size  = C_PERLIN_NOISE_BUFFER_SIZE,
			_buff  = buffer_create(_size << 2, buffer_fast, 1),  // Uses unsigned8 to store RGBA
			_buff2 = buffer_create(_size << 2, buffer_fixed, 4), // Uses float32 to store single value
			_peek  = 0;
	
		// Draw perlin noise to a surface
		shader_set_perlin_noise();
		surface_set_target(_surf)

			draw_clear_alpha(c_black, 0);
			draw_primitive_begin_texture(pr_trianglestrip, -1);
			draw_vertex_texture(0, 0, 0, 0);
			draw_vertex_texture(C_PERLIN_NOISE_SIZE, 0, 1, 0);
			draw_vertex_texture(0, C_PERLIN_NOISE_SIZE, 0, 1);
			draw_vertex_texture(C_PERLIN_NOISE_SIZE, C_PERLIN_NOISE_SIZE, 1, 1);
			draw_primitive_end();
		
		shader_reset();
		surface_reset_target();

		// Convert surface to normal buffer
		buffer_get_surface(_buff, _surf, 0);
		surface_free(_surf);
	
		// Remove 3 channels from RGBA since we only need 1
		buffer_seek(_buff2, buffer_seek_start, 0);
		for (var _b = 0; _b < _size; _b++)
		{
			buffer_write(_buff2, buffer_f32, buffer_peek(_buff, _peek, buffer_u8)/255.0);
			_peek += 4;
		}
	
		buffer_delete(_buff);
	
		return _buff2;	
	}

	function create_perlin_hash_table()
	{
		// Creates a permutation hash table used for perlin noise shader
	
		var _size    = 256,
			_values  = ds_list_create(),
			_table   = array_create(256),
			_index   = 0,
			_num	 = 0,
		
		// Populate values 
		while (_index < 256)
		{
			_values[| _index] = _index++;
		}
	
		// Creates random permutation of values from 0 - 255
		_index = 0;
		while (_index < 256)
		{
			_num = irandom(--_size);
			_table[_index++] = _values[| _num];
			ds_list_delete(_values, _num);
		}
		
		ds_list_destroy(_values);

		return _table;
	}

#endregion
