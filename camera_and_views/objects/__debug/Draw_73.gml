if (!debug_on)
	exit;

if (draw_navgrid)
	with (ast_navgrid)
	{
		draw_set_alpha(0.4);
		mp_grid_draw(grid);
		draw_set_alpha(1.0);
	}