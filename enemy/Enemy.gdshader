shader_type canvas_item;

uniform float intensity = 0.0;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	COLOR.rgb = vec3(COLOR.r, COLOR.g * intensity, COLOR.b * intensity);
}
