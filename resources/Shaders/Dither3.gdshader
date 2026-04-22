shader_type spatial;
render_mode unshaded;

// Input parameters
uniform float dither_intensity : hint_range(0.0, 1.0) = 0.5;
uniform float dither_scale : hint_range(0.1, 10.0) = 1.0;
uniform sampler2D screen_texture : hint_screen_texture;

// Blue noise texture (16x16) - needs to be provided as a uniform
uniform sampler2D blue_noise : hint_screen_texture;

// Blue noise lookup function
float blue_noise_lookup(vec2 coord) {
    vec2 noise_coord = coord * dither_scale;
    vec2 uv = fract(noise_coord) * 16.0;
    vec2 pixel = floor(uv);
    vec2 f = fract(uv);
    
    // Bilinear filtering
    float s00 = texture(blue_noise, pixel * (1.0 / 16.0)).r;
    float s10 = texture(blue_noise, (pixel + vec2(1.0, 0.0)) * (1.0 / 16.0)).r;
    float s01 = texture(blue_noise, (pixel + vec2(0.0, 1.0)) * (1.0 / 16.0)).r;
    float s11 = texture(blue_noise, (pixel + vec2(1.0, 1.0)) * (1.0 / 16.0)).r;
    
    float s0 = mix(s00, s10, f.x);
    float s1 = mix(s01, s11, f.x);
    
    return mix(s0, s1, f.y);
}

void fragment() {
    // Get screen texture coordinates
    vec2 screen_uv = SCREEN_UV;
    
    // Sample screen texture
    vec4 screen_color = texture(screen_texture, screen_uv);
    
    // Get blue noise value
    float noise = blue_noise_lookup(screen_uv);
    
    // Apply dithering
    float dither = noise - 0.5;
    float dithered_alpha = screen_color.a + dither * dither_intensity;
    
    // Output final color
    ALBEDO = screen_color.rgb;
    ALPHA = clamp(dithered_alpha, 0.0, 1.0);
}
