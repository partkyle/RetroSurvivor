shader_type canvas_item;

uniform sampler2D screen : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
    vec4 color = texture(screen, UV);

    // Convert color to grayscale using weighted average (human eye perception model)
    float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));

    // Apply sepia tone effect using predefined sepia color values
    vec3 sepiaColor = vec3(1.2 * gray, 1.0 * gray, 0.8 * gray);

    // Output final sepia-tinted color
    COLOR = vec4(sepiaColor, color.a);
}