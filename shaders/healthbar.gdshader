shader_type spatial;

uniform float health_percent : hint_range(0.0, 1.0, 0.01) = 1.0;

uniform vec3 healthy_color : source_color = vec3(0.0, 1.0, 0.0);
uniform vec3 injured_color : source_color = vec3(1.0, 0.0, 0.0);


void vertex() {
    mat4 modified_model_view = VIEW_MATRIX * mat4(
        INV_VIEW_MATRIX[0],
        INV_VIEW_MATRIX[1],
        INV_VIEW_MATRIX[2],
        MODEL_MATRIX[3]
    );
    MODELVIEW_MATRIX = modified_model_view;
}

void fragment() {
	float xval = UV.x;
	float injured_percent = 1.0 - health_percent;
	ALBEDO = step(injured_percent, 1.0-xval) * mix(healthy_color, injured_color, injured_percent * 1.25);
	EMISSION = ALBEDO;
	ALPHA = 0.99;
}

