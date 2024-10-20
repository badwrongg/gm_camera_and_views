if (!debug_on)
	exit;

draw_set_font(fnt_debug);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

DEBUG_TEXT;
TX 40;
TY 40;

TEXT "- camera and views -" ENDLINE;
TEXT "fps: " + string(fps) ENDLINE;
TEXT "win: " + string(window_get_width()) + "x" + string(window_get_height()) ENDLINE;
TEXT "gui: " + string(display_get_gui_width()) + "x" + string(display_get_gui_height()) ENDLINE;
TEXT "app: " + string(surface_get_width(application_surface)) + "x" + string(surface_get_height(application_surface)) ENDLINE;
TEXT controls ENDLINE;
NEWLINEx 4;