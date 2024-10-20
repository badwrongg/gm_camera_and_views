// Process loader structs until stack is empty, then goto first room or next room

if (ds_stack_empty(load_stack))
{
	ds_stack_destroy(load_stack);
	
	if (first_room != noone)
		room_goto(first_room);
	else if (room_exists(room_next(room)))
		room_goto_next();
	
	instance_destroy(id);
}
else
{
	var _top = ds_stack_top(load_stack);
	
	// Loaders return true if finished
	if (_top.process(id)) ds_stack_pop(load_stack);
}