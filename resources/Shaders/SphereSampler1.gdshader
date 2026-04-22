shader_type spatial;
render_mode depth_test_disabled, unshaded, fog_disabled;

uniform sampler2D sphere_noise : repeat_disable, filter_nearest;
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D depth_texture : hint_depth_texture, filter_linear_mipmap;
uniform sampler2D normal_rough_texture : hint_normal_roughness_texture;
uniform float min_step : hint_range(0.0, 1.0, 0.01) = 0.4; // min step for the smoothstep() function
uniform float max_step : hint_range(0.0, 1.0, 0.01) = 0.6; // max step for the smoothstep() function
uniform float gamma: hint_range(0.0, 10.0, 0.01) = 2.2;
uniform float brightness = 1.0;
uniform float contrast = 1.0;
uniform float saturation = 1.0;

void vertex() {
  POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment()
{
	vec2 NoiseUV = UV;
	NoiseUV.y = 1.0-NoiseUV.y;
	vec4 noise = texture(sphere_noise, NoiseUV);
		vec4 input = texture(screen_texture, SCREEN_UV);
	vec4 normal_rough = texture(normal_rough_texture, SCREEN_UV);
	vec3 appliedColor = vec3(1.0, 0.85, 0.85);
	if((input.r >= (input.g + input.b)) && input.r > 0.25)
	{
		appliedColor = vec3(1.0, 0.0, 0.0);
	}
	if((input.g >= (input.r + input.b)) && input.g > 0.25)
	{
		appliedColor = vec3(0.2, 1.0, 0.2);
	}
	if((input.b >= (input.r + input.g)) && input.b > 0.25)
	{
		appliedColor = vec3(0.2, 0.2, 1.0);
	}
    ivec2 q = ivec2(FRAGCOORD.xy);
    
    // Sample 9 pixels around the center
    vec3 n[9];
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            n[i*3+j] = texelFetch(normal_rough_texture, q + ivec2(i-1, j-1), 0).rgb;
			n[i*3+j] *=  2.0 - 1.0;
        }
    }

    // 2. Sobel kernels
    vec3 sobel_edge_h = n[2] + (2.0*n[5]) + n[8] - (n[0] + (2.0*n[3]) + n[6]);
    vec3 sobel_edge_v = n[0] + (2.0*n[1]) + n[2] - (n[6] + (2.0*n[7]) + n[8]);

    // 3. Combine horizontal and vertical
    vec3 sobel = sqrt((sobel_edge_h * sobel_edge_h) + (sobel_edge_v * sobel_edge_v));
	float thresh = 0.3;
	if(sobel.r > thresh) // if pixel is sobel edge, mark as edge.
	{
		ALBEDO = appliedColor;
	}
	else if(sobel.r < thresh)// if pixel is not sobel edge, dither that pixel.
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
        float threshold = noise.x / 2.0;
        float dithered = step(threshold, color.r);
        vec3 coloredDither = vec3(dithered, dithered * 0.85, dithered * 0.85);
        
        // Output the result
        //ALBEDO = vec3(dithered, dithered, dithered);
		ALBEDO = coloredDither;
		if (dithered >= 0.5)
		{
			ALBEDO = appliedColor;
		}
	}
}
