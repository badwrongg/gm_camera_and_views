/// @description Mouse Over False

#macro widget_mouse_over alarm[11]

/* 
	This alarm acts as a boolean "mouse_over" variable.
	If a cursor object calls on_mouse_over() it sets widget_mouse_over = true;
	Then in draw events you can use widget_mouse_over as a boolean to draw
	some type of button highlighting or whatever.  On the next step this alarm
	will go back to zero and widget_mouse_over will be a false boolean.
	
	The major benefit is not having to track when the mouse cursor is no longer
	hovering over the object, because if it still hovers over it then the alarm
	will be set to true again.
*/