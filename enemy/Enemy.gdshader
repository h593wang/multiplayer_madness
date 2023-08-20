shader_type canvas_item;

uniform sampler2D circle;

void fragment() {
	vec2 textureS = vec2(textureSize(circle, 0));
	vec4 spriteColor = texture(circle, UV);
	COLOR = texture(TEXTURE, UV);
	COLOR.a = COLOR.a * spriteColor.a;
}
