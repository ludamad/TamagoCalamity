/*
	Glitch Effect Shader by Yui Kinomoto @arlez80

	MIT License
*/

shader_type canvas_item;

uniform float shake_power = 0.1;
uniform float shake_rate : hint_range( 0.0, 1.0 ) = 0.2;
uniform float shake_speed = 5.0;
uniform float shake_block_size = 62.5;
uniform float shake_color_rate : hint_range( 0.0, 1.0 ) = 0.01;

float random( float seed )
{
	return fract( 543.2543 * sin( dot( vec2( seed, seed ), vec2( 3525.46, -54.3415 ) ) ) );
}

void fragment( )
{
	float enable_shift = float(
		random( trunc( (TIME/3.0) * shake_speed ) )
	<	shake_rate
	);

	vec2 fixed_uv = UV/2.0;
	fixed_uv.x += (
		random(
			( trunc( UV.y * shake_block_size ) / shake_block_size )
		+	(TIME/3.0)
		) - 0.5
	) * shake_power * enable_shift;

	fixed_uv *= 2.0;
	vec4 pixel_color = textureLod( TEXTURE, fixed_uv, 0.0 );
	pixel_color.r = mix(
		pixel_color.r
	,	textureLod( TEXTURE, fixed_uv + vec2( shake_color_rate, 0.0 ), 0.0 ).r
	,	enable_shift
	);
	pixel_color.b = mix(
		pixel_color.b
	,	textureLod( TEXTURE, fixed_uv + vec2( -shake_color_rate, 0.0 ), 0.0 ).b
	,	enable_shift
	);
	COLOR = pixel_color;
}
