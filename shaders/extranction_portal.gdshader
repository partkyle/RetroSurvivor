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
	float ring_alpha = step(1.0, sin(ring) * 0.5 + 1.0);

	vec3 final_ring_color = color * texture(noise_texture, UV + TIME * 0.15).r;
	final_ring_color.b *= 100.0;
	final_ring_color.g *= 100.0;

	ALBEDO = final_ring_color;

	ALPHA = (1.0 - step(0.5, dist)) * ring_alpha;
}

void light() {}
