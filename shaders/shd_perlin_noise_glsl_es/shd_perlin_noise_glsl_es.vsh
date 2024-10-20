precision highp float;

#if __VERSION__ >= 130
	#define attribute in
	#define varying out
#endif

attribute vec3 in_Position;
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;

varying vec2 tex_coord;

void main()
{
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position.xyz, 1.0);
    tex_coord = in_TextureCoord;
}
