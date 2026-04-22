shader_type spatial;

// Input parameters
uniform sampler2D screen_texture : hint_screen_texture;

float gradient_noise(vec2 uv)
{
    vec3 magic = vec3(0.06711056, 0.00583715, 52.9829189);
    return fract(magic.z * fract(dot(uv, magic.xy)));
}

void fragment() 
{
	float s = 4.0;
	vec4 color = texture(screen_texture, SCREEN_UV, 0.0);
	vec3 lum_magic = vec3(color.rgb) * vec3(0.29900, 0.58700, 0.11400);
	float pixel_lum = lum_magic.r + lum_magic.g + lum_magic.b;
	
    vec3 magic = vec3(0.06711056, 0.00583715, 52.9829189);
	float n = fract(magic.z * fract(dot(FRAGCOORD.xy, magic.xy)));
	if(n > 0.75)
	{
		color.r = floor(color.r * 2.0 + n) / 2.0;
		color.g = floor(color.r * 2.0 + n) / 2.0;
		color.b = floor(color.r * 2.0 + n) / 2.0;
	}
	//float n = gradient_noise(FRAGCOORD.xy);
	
	ALBEDO = color.rgb;
}
