var _x_axis = keyboard_check(ord("D")) - keyboard_check(ord("A")),
	_y_axis = keyboard_check(ord("S")) - keyboard_check(ord("W"));
	
if (_x_axis != 0 || _y_axis != 0)
{
	var _dir = point_direction(0, 0, _x_axis, _y_axis);
	x += lengthdir_x(move_speed, _dir);
	y += lengthdir_y(move_speed, _dir);
	
	facing_direction = _dir;
	image_speed = 1;
}
else
{
	image_speed = 0;
	image_index = 0;
}

sprite_index = anims[round(facing_direction / P_FACING_ANGLES) mod P_FACING_DIRS];