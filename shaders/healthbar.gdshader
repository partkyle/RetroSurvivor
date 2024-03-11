shader_type spatial;
render_mode depth_draw_opaque;

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
	if (PROJECTION_MATRIX[3][3] != 0.0) {
		float h = abs(1.0 / (2.0 * PROJECTION_MATRIX[1][1]));
		float sc = (h * 2.0); //consistent with Y-fov
		MODELVIEW_MATRIX[0]*=sc;
		MODELVIEW_MATRIX[1]*=sc;
		MODELVIEW_MATRIX[2]*=sc;
	} else {
		float sc = -(MODELVIEW_MATRIX)[3].z;
		MODELVIEW_MATRIX[0]*=sc;
		MODELVIEW_MATRIX[1]*=sc;
		MODELVIEW_MATRIX[2]*=sc;
	}
}

void fragment() {
	float xval = UV.x;
	float injured_percent = 1.0 - health_percent;
	//vec3 color = step(0.01, xval) * vec3(0.0) + step(xval, 0.99) * (step(injured_percent, 1.0-xval) * mix(healthy_color, injured_color, injured_percent * 1.25)) + step(0.99, xval) * vec3(0.0);
	//ALBEDO = color;
	ALBEDO = step(injured_percent, 1.0-xval) * mix(healthy_color, injured_color, injured_percent * 1.25);
	EMISSION = ALBEDO;
}

