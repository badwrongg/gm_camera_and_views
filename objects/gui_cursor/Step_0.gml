x = gui_mouse_x();
y = gui_mouse_y();

// Simple cursor state for clicking or holding of left mouse
if (widget_active != noone)
{
	if (mouse_check_button_released(mb_left))
	{
		widget_active.on_mouse_left_clicked(x, y);
		widget_active = noone;
	}
	else if (mouse_check_button(mb_left))
		widget_active.on_mouse_left_held(x, y);
	else
		widget_active = noone;	
}
else
{
	var _widget = instance_position(x, y, __widget);

	if (_widget != noone)
	{		
		if (mouse_check_button_pressed(mb_left))
			widget_active = _widget;
		else
			_widget.on_mouse_over(x, y);	
	}
}