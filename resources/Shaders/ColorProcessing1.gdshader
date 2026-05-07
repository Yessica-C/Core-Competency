shader_type spatial;
render_mode depth_test_disabled, unshaded, fog_disabled;

uniform sampler2D screen_texture : hint_screen_texture;
uniform float redThresh = 0.5;
uniform float greenThresh = 0.5;
uniform float blueThresh = 0.5;
uniform float cyanThresh = 0.5;
uniform float magentaThresh = 0.5;
uniform float yellowThresh = 0.5;

void vertex() {
  POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
	
	vec4 input = texture(screen_texture, SCREEN_UV);
	vec3 appliedColor = vec3(1.0, 1.0, 1.0);
	float redDistance =
		((input.r - 1.0)*(input.r - 1.0)) +
		((input.g - 0.0)*(input.g - 0.0)) +
		((input.b - 0.0)*(input.b - 0.0));
	float greenDistance =
		((input.r - 0.0)*(input.r - 0.0)) +
		((input.g - 1.0)*(input.g - 1.0)) +
		((input.b - 0.0)*(input.b - 0.0));
	float blueDistance =
		((input.r - 0.0)*(input.r - 0.0)) +
		((input.g - 0.0)*(input.g - 0.0)) +
		((input.b - 1.0)*(input.b - 1.0));
	float cyanDistance =
		((input.r - 0.0)*(input.r - 0.0)) +
		((input.g - 1.0)*(input.g - 1.0)) +
		((input.b - 1.0)*(input.b - 1.0));
	float magentaDistance =
		((input.r - 1.0)*(input.r - 1.0)) +
		((input.g - 0.0)*(input.g - 0.0)) +
		((input.b - 1.0)*(input.b - 1.0));
	float yellowDistance =
		((input.r - 1.0)*(input.r - 1.0)) +
		((input.g - 1.0)*(input.g - 1.0)) +
		((input.b - 0.0)*(input.b - 0.0));
	
	if(redDistance < redThresh)
	{
		appliedColor = vec3(1.0, 0.0, 0.0);
	}
	if(greenDistance < greenThresh)
	{
		appliedColor = vec3(0.0, 1.0, 0.0);
	}
	if(blueDistance < blueThresh)
	{
		appliedColor = vec3(0.0, 0.0, 1.0);
	}
	if(cyanDistance < cyanThresh)
	{
		appliedColor = vec3(0.0, 1.0, 1.0);
	}
	if(magentaDistance < magentaThresh)
	{
		appliedColor = vec3(1.0, 0.0, 1.0);
	}
	if(yellowDistance < yellowThresh)
	{
		appliedColor = vec3(1.0, 1.0, 0.0);
	}
	ALBEDO = appliedColor;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
