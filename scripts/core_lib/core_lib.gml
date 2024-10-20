enum e_depth
{
	system = -1600
}

function slog() 
{
	var _msg = "** Log: ", _arg;
	for (var _i = 0; _i < argument_count; _i++)
	{
		_arg = argument[_i];
		if is_string(_arg) { _msg += _arg+" "; continue; }
	    _msg += string(_arg)+" ";
	}  
	show_debug_message(_msg);
}

function screenshot_dated(_label)
{
	screen_save(_label+"_"+string(current_month)+"-"
		+ string(current_day)+"_"
		+ string(current_hour)+"-" 
		+ string(current_minute)+"-" 
		+ string(current_second)+".png");	
}

function lerp_inverse(_min, _max, _val)
{
	return (_val - _min) / (_max - _min);	
}

function lerp_angle(_source, _dest, _position)
{
	// Normalized to 0 - 360
	return ((lerp(_source, _source + angle_difference(_dest, _source), _position) mod 360) + 360) mod 360;	
}

function smooth_step(_a, _b, _x)
{
	var _t = clamp((_x - _a) / (_b - _a), 0.0, 1.0);
	return (_t * _t * (3.0 - 2.0 * _t));
}

function range_wrap(_value, _increment, _max)
{
	return (_max + _value + _increment) mod _max;
}

function draw_bbox()
{
	draw_line(bbox_left,  bbox_top,    bbox_right, bbox_top);
	draw_line(bbox_left,  bbox_bottom, bbox_right, bbox_bottom);
	draw_line(bbox_left,  bbox_top,    bbox_left,  bbox_bottom);
	draw_line(bbox_right, bbox_top,    bbox_right, bbox_bottom);	
}