shader_type canvas_item;
 
uniform float shake_power = 0.7;
uniform float shake_rate : hint_range( 0.0, 1.0 ) = 0.2;
uniform float shake_speed = 5.0;
uniform float shake_block_size = 122.5;
uniform float shake_color_rate : hint_range( 0.0, 1.0 ) = 0.01;
float rand(vec2 n) { 
	return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float noise(vec2 p){
	vec2 ip = floor(p);
	vec2 u = fract(p);
	u = u*u*(3.0-2.0*u);
	
	float res = mix(
		mix(rand(ip),rand(ip+vec2(1.0,0.0)),u.x),
		mix(rand(ip+vec2(0.0,1.0)),rand(ip+vec2(1.0,1.0)),u.x),u.y);
	return res*res;
}
float random( float seed )
{
	return fract( 543.2543 * sin( dot( vec2( seed, seed ), vec2( 3525.46, -54.3415 ) ) ) );
}

uniform vec2 direction = vec2(1, 0);
uniform float speed = 0.1;

vec4 overlay(vec4 base, vec4 blend){
	vec4 limit = step(0.5, base);
	return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), limit);
}

void fragment()
{
    vec2 uv = UV;
	float rotation = 0.01 * (TIME/8.0);
	rotation += (mod((TIME/8.0)/10.0, 1.0) + mod(1.0 - (TIME/8.0)/10.0, 1.0)) * 0.1;
    float sine = sin(rotation);
    float cosine = cos(rotation);
	vec2 offset = vec2(1,1);
    uv.x = uv.x + offset.x * cosine - offset.y * sine;
    uv.y = uv.y + offset.x * sine + offset.y * cosine;
	uv *= 15.0;
	float enable_shift = float(
		random( trunc( (TIME/8.0) * shake_speed ) )
	<	shake_rate
	);

	vec2 fixed_uv = uv;
	fixed_uv.x += (
		random(
			( trunc( uv.y * shake_block_size ) / shake_block_size )
		+	(TIME/8.0)
		) - 0.5
	) * shake_power * enable_shift;

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
    //vec4 col = texture(TEXTURE, uv);
   	// COLOR = pixel_color;
	// image texture
	vec4 base = pixel_color; //texture(TEXTURE, UV);
	// noise texture
	vec4 blend = vec4(noise(UV.xy * (TIME/8.0)),noise(uv.xy * (TIME/8.0)),noise(UV.yx * (TIME/8.0)),noise(uv.yx * (TIME/8.0)));
	
	COLOR = overlay(base, blend);
}
