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

function smooth_step(_a, _b, _x)
{
	var _t = clamp((_x - _a) / (_b - _a), 0.0, 1.0);
	return (_t * _t * (3.0 - 2.0 * _t));
}

function range_wrap(_value, _increment, _max)
{
	return (_max + _value + _increment) mod _max;
}