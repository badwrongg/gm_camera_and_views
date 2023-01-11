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