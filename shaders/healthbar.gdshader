shader_type spatial;

uniform float fillPercent : hint_range(0.0, 1.0, 0.01) = 1.0;
uniform float borderSize : hint_range(0.0, 0.5, 0.1) = 0.1;
uniform vec2 aspectRatio = vec2(1.0);

uniform vec3 healthyColor : source_color = vec3(0.0, 1.0, 0.0);
uniform vec3 injuredColor : source_color = vec3(1.0, 0.0, 0.0);


float sdRect(vec2 p, vec2 sz) {
  vec2 d = abs(p) - sz;
  float outside = length(max(d, 0.));
  float inside = min(max(d.x, d.y), 0.);
  return outside + inside;
}

void vertex() {
    mat4 modified_model_view = VIEW_MATRIX * mat4(
        INV_VIEW_MATRIX[0],
        INV_VIEW_MATRIX[1],
        INV_VIEW_MATRIX[2],
        MODEL_MATRIX[3]
    );

    MODELVIEW_MATRIX = modified_model_view;
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);

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
	// calculate the border using a SDF of a rectangle
	// we want a full rectangle, minus the width of the border, normalized by aspect ratio
	vec2 rectSize = vec2(1.0) - vec2(borderSize, borderSize) / aspectRatio;
	// offset rect to the center
	float offset = 0.5;
	float rect = sdRect(UV - offset, rectSize * 0.5);
	float borderMask = 1.0 - step(0.0, rect);

	float xval = UV.x;
	float injured_percent = 1.0 - fillPercent;
	ALBEDO = step(injured_percent, 1.0-xval) * mix(healthyColor, injuredColor, injured_percent * 1.25) * borderMask;
	EMISSION = ALBEDO;
}

// ignore lighting
void light() {

}
