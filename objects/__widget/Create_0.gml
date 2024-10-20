on_mouse_over		   = method(id, on_mouse_over);
on_mouse_left_clicked  = method(id, on_mouse_left_clicked);
on_mouse_left_held	   = method(id, on_mouse_left_held);
on_mouse_right_clicked = method(id, on_mouse_left_clicked);
on_mouse_right_held	   = method(id, on_mouse_left_held);

// For GUI objects run event_inherited last
// because it sets starting scale and repositions
event_inherited();