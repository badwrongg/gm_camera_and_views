draw_self();

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text((bbox_right + bbox_left) * 0.5, (bbox_top + bbox_bottom) * 0.5 + (image_index > 0) * 4, label);