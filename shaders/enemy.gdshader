shader_type spatial;
render_mode depth_prepass_alpha;

uniform vec3 start_color : source_color = vec3(0.0, 1.0, 0.0);
uniform vec3 end_color: source_color = vec3(1.0, 0.0, 0.0);
uniform float mix_amount: hint_range(0.0, 1.0, 0.05) = 0.0;

uniform sampler2D noise_texture;

// The height of the dissolve effect. This can be thought of as a percentage
// of how much is dissolved.
uniform float dissolve_height : hint_range(0.0, 1.0, 0.01) = 1.0;

// How much of the noise should effect the value
uniform float noise_scale: hint_range(0.0, 1.0, 0.1) = 0.1;
uniform float time_scale: hint_range(0.0, 10.0, 0.1) = 0.0;

// Color the object should Glow.
// This requires that the camera have an environment that supports glowing.
// This color also needs to have a value > 1.0 for whatever color we want to
// glow.
uniform vec3 glow_color : source_color;
uniform float glow_thickness: hint_range(0.0, 1.0) = 0.05;

varying float y_pos;

void vertex() {
	// normalize from (-1.0, 1.0) => (0.0, 1.0)
	y_pos = fma(VERTEX.y, 0.5, 0.5);
}

void fragment() {
	// Called for every pixel the material is visible on.
	ALBEDO = mix(start_color, end_color, mix_amount);

	// get a noise value and only use one the r channel
	float noise_at = texture(noise_texture, UV + TIME * time_scale).r * noise_scale;

	// we want to normalize the current_dissolve_height so that we get something
	// between 0.0 and 1.0. This can cause some floating point issues
	float current_dissolve_height = 0.0;

	if (dissolve_height < 1.0) {
		//// Originally I was dividing this by 2.0, but that's before I added in the
		//// noise_scale variable.
		current_dissolve_height = (y_pos + noise_at);
	}

	// fade out the parts of the shape that should be gone
	ALPHA = 1.0 - step(dissolve_height, current_dissolve_height);

	// add the glow line based on the glow_thickness using the glow_color
	EMISSION = step(dissolve_height - glow_thickness, current_dissolve_height) * glow_color;
}
