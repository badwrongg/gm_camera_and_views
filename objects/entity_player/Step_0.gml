var _x_axis = keyboard_check(ord("D")) - keyboard_check(ord("A")),
	_y_axis = keyboard_check(ord("S")) - keyboard_check(ord("W")),
	_speed  = 1.0 + keyboard_check(vk_shift) * run_speed_mod;

if (_x_axis != 0 || _y_axis != 0)
{
	facing_direction = point_direction(0, 0, _x_axis, _y_axis);	
	var	_move_speed = _speed * move_speed;	
	x += lengthdir_x(_move_speed, facing_direction);
	y += lengthdir_y(_move_speed, facing_direction);	
	image_speed = _speed;
}
else
{
	image_speed = 0;
	image_index = 0;
}

sprite_index = anims[round(facing_direction / P_FACING_ANGLES) mod P_FACING_DIRS];