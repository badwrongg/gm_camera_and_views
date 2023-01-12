#macro DEBUG_TEXT var _scale = get_gui_dimensions()[e_gui_dimension.scale], _textH = string_height("H") * _scale;
#macro TX var _textX = 
#macro TY var _textY = 
#macro TEXT draw_text_transformed(_textX, _textY,
#macro ENDLINE , _scale, _scale, 0); _textY += _textH
#macro NEWLINE _textY += _textH
#macro NEWLINEx _textY += _textH * 

debug_on = true;
draw_navgrid = false;
draw_overlay = true;

show_debug_overlay(draw_overlay);	

controls =
@"
Esc: Exit
F1: Toggle Debug
F: Toggle Fullscreen
G: Toggle Point-sampling
T: Toggle Viewports
Num +/-: Scale GUI
Mouse Wheel: Zoom
WASD: Move Player
";