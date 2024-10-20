var _pos_w = (sprite_get_xoffset(position_sprite) - 1),
	_pos_l = bbox_left + _pos_w,
	_pos_r = bbox_right - _pos_w,
	_pos_y = (bbox_bottom + bbox_top) * 0.5;

draw_self();

draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_text((bbox_left + bbox_right) * 0.5, bbox_top, label);

draw_set_valign(fa_top);
for (var _t = 0, _count = value_divisions + 1, _pos, _value_x, _value; _t <= _count; _t++)
{
	_pos	 = _t / _count;
	_value_x = lerp(bbox_left, bbox_right, _pos);
	_value   = lerp(value_min, value_max, _pos);
	draw_text(_value_x, bbox_bottom, (value_round ? round(_value) : _value));
}


draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_text(bbox_right + 8, _pos_y, value);

draw_sprite(position_sprite, widget_mouse_over, lerp(_pos_l, _pos_r, value_pos), _pos_y);