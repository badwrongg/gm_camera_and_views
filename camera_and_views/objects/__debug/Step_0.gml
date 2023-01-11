if (keyboard_check_pressed(vk_f1))
{
	debug_on = !debug_on;
	
	if (debug_on)
	{
		show_debug_overlay(draw_overlay);	
	}
	else
	{
		show_debug_overlay(false);	
	}
}

if (!debug_on)
	exit;

if (keyboard_check_pressed(vk_f10))
	room_restart();
	
if (keyboard_check_pressed(vk_f11))
	game_restart();

if (keyboard_check_pressed(vk_f5))
	draw_navgrid = !draw_navgrid;