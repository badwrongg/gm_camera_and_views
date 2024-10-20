/// feather ignore all

event_user(0); // Declare functions
event_user(1); // Create game camera(s)

game_cameras      = get_game_camera_array();
room_start_ran    = false;
window_width      = -1;
window_height     = -1;
windowed_width    = DISPLAY_DEFAULT_WINDOWED_WIDTH;
windowed_height   = DISPLAY_DEFAULT_WINDOWED_HEIGHT;
window_fullscreen = DISPLAY_DEFAULT_FULLSCREEN;

window_resize(false);
gpu_set_tex_filter(DISPLAY_DEFAULT_TEXTURE_FILTERING);