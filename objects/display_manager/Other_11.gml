/// @description Create game camera(s)
/// feather ignore all

// 1 single full-window camera
// add_game_camera(0, VIEW_DEFAULT_WIDTH, VIEW_DEFAULT_HEIGHT, 0, 0, 1, 1, VIEW_DEFAULT_FOLLOW_OBJECT);

// 2 cameras separated horizontally
// add_game_camera(0, VIEW_DEFAULT_WIDTH, VIEW_DEFAULT_HEIGHT, 0, 0, 1, 0.5, VIEW_DEFAULT_FOLLOW_OBJECT);
// add_game_camera(1, VIEW_DEFAULT_WIDTH, VIEW_DEFAULT_HEIGHT, 0, 0.5, 1, 0.5, VIEW_DEFAULT_FOLLOW_OBJECT);

// 4 cameras in each quarter of the screen
// add_game_camera(0, VIEW_DEFAULT_WIDTH, VIEW_DEFAULT_HEIGHT, 0, 0, 0.5, 0.5, VIEW_DEFAULT_FOLLOW_OBJECT);
// add_game_camera(1, VIEW_DEFAULT_WIDTH, VIEW_DEFAULT_HEIGHT, 0.5, 0, 0.5, 0.5, VIEW_DEFAULT_FOLLOW_OBJECT);
// add_game_camera(2, VIEW_DEFAULT_WIDTH, VIEW_DEFAULT_HEIGHT, 0, 0.5, 0.5, 0.5, VIEW_DEFAULT_FOLLOW_OBJECT);
// add_game_camera(3, VIEW_DEFAULT_WIDTH, VIEW_DEFAULT_HEIGHT, 0.5, 0.5, 0.5, 0.5, VIEW_DEFAULT_FOLLOW_OBJECT);

// 3 cameras with the bottom to taking up half the window width
// The example entity_player uses this camera layout
add_game_camera(0, VIEW_DEFAULT_WIDTH, VIEW_DEFAULT_HEIGHT, 0, 0, 1, 0.5, VIEW_DEFAULT_FOLLOW_OBJECT);
add_game_camera(1, VIEW_DEFAULT_WIDTH, VIEW_DEFAULT_HEIGHT, 0, 0.5, 0.5, 0.5, VIEW_DEFAULT_FOLLOW_OBJECT);
add_game_camera(2, VIEW_DEFAULT_WIDTH, VIEW_DEFAULT_HEIGHT, 0.5, 0.5, 0.5, 0.5, VIEW_DEFAULT_FOLLOW_OBJECT);