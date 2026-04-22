shader_type spatial;

const mat4 BAYER4 = mat4(
	vec4(0.0,  12.0, 3.0,  15.0),
	vec4(8.0,  4.0,  11.0, 7.0),
	vec4(2.0,  14.0, 1.0,  13.0),
	vec4(10.0, 6.0,  9.0,  5.0)	
);

uniform float gamma: hint_range(0.0, 10.0, 0.01) = 2.2;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform float brightness = 1.0;
uniform float contrast = 1.0;
uniform float saturation = 1.0;

float bayer4(vec2 pixel)
{
	ivec2 p = ivec2(mod(pixel, 4.0));
	return BAYER4[p.x][p.y] / 16.0;
}


void fragment() 
{
	vec4 color = texture(screen_texture, SCREEN_UV, 0.0);
	
	// Apply gamma correction
	color = pow(color, vec4(gamma));
	
	// Apply brightness, contrast, and saturation
	color.rgb = (color.rgb - 0.5) * contrast + 0.5;
	color.rgb *= brightness;
	
	// Apply saturation
	vec3 gray = vec3(dot(color.rgb, vec3(0.299, 0.587, 0.114)));
	color.rgb = mix(gray, color.rgb, saturation);
	
	// Dithering
	float threshold = bayer4(FRAGCOORD.xy);
	float dithered = step(threshold, color.r);
	
	float ditheredr = step(threshold, color.r);
	float ditheredg = step(threshold, color.g);
	float ditheredb = step(threshold, color.b);
	vec3 coloredDither = vec3(ditheredr, ditheredg, ditheredb);
	
	// Output the result
	//ALBEDO = vec3(dithered, dithered, dithered);
	ALBEDO = coloredDither;
}	