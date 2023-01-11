// https://www.shadertoy.com/view/MlB3D3
// https://hero.handmade.network/episode/chat/chat018/
// By Casey Muratori    2015-05-30

// Retrieved from JuJu Adams GitHub 2023-01-11
// https://github.com/JujuAdams/Pixel-Art-Upscaling

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 u_texel_size;
uniform vec2 u_pixel_scale;

void main()
{
    vec2 pos = v_vTexcoord / u_texel_size;
    vec2 uv = floor(pos) + 0.5 + 1.0 - clamp(u_pixel_scale * (1.0 - fract(pos)), 0.0, 1.0);
	
    gl_FragColor = v_vColour * texture2D(gm_BaseTexture, uv * u_texel_size);
}
