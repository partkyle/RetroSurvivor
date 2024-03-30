shader_type spatial;

uniform vec3 color: source_color;
uniform sampler2D noise_texture;

uniform float ring_width = 0.02;
uniform float time_scale: hint_range(0.0, 100.0, 0.1) = 10.0;

float circle(vec2 samplePosition, float radius) {
    return length(samplePosition) - radius;
}

void fragment() {
	vec2 center = vec2(0.5);
	float dist = distance(UV, center);
	float ring = dist / ring_width + TIME * time_scale;

	vec3 final_ring_color = (1.0 - vec3(sin(ring))) * color * texture(noise_texture, UV + TIME * 0.15).rgb;
	ALBEDO = final_ring_color;
	//ALPHA = (1.0 - step(1.0 - circle(UV - center, 0.5), 1.0)) * (step(1.0 - final_ring_color.r, 1.0));
	ALPHA = (1.0 - step(1.0 - circle(UV - center, 0.5), 1.0)) * ring;

}

void light() {}
