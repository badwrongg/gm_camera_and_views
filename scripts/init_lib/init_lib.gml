/* 
	Solution for game intialization.  The object __game_init creates a stack of these structs
	and then processes the top each step until the stack is empty. Allows for any given part to 
	use multiple steps for any costly loading as they will be processed until returning true.
	
	All loaders should inherit from __loader_base struct and override the process() function.
*/

function __loader_base() constructor
{
	static process = function(_init) { return true; }
}

function loader_system() : __loader_base() constructor
{
	static process = function(_init)
	{
		// Examples for system loading...
		// ** Create gamestate object
		// ** Load system data
		// ** Load persistent camera
		
		randomize();
		
		instance_create_depth(0, 0, e_depth.system, gamestate);
		instance_create_depth(0, 0, e_depth.system, display_manager);
		instance_create_depth(0, 0, e_depth.system, gui_cursor);
		
		if (_init.debug_build) 
			instance_create_depth(0, 0, e_depth.system, __debug);
			
		return true;
	}
}

function loader_assets() : __loader_base() constructor
{
	static process = function(_init)
	{
		// Examples for asset loading...
		// ** Load audio groups
		// ** Load graphical data such as fetching common texture groups
		
		get_perlin_noise_buffer(); // Pre-create the buffer now
		
		return true;
	}
}

function loader_game_data() : __loader_base() constructor
{
	static process = function(_init)
	{
		// Examples for loading game data...
		// ** Load player data
		// ** Load game type objects
		
		return true;
	}
}