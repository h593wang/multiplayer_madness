shader_type canvas_item;

uniform float intensity = 0.0;
uniform sampler2D circle;

void fragment() {
	vec2 textureS = vec2(textureSize(circle, 0));
	vec4 spriteColor = texture(circle, UV);
	COLOR = texture(TEXTURE, UV);
	COLOR.rgb = vec3(COLOR.r, COLOR.g * intensity, COLOR.b * intensity);
	COLOR.a = COLOR.a * spriteColor.a;
}
