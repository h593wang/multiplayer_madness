shader_type canvas_item;

uniform bool invincible = false;
uniform bool dead = false;

void fragment() {
	if (invincible) {
		float cycle = sin(TIME * 20.0);
		if (cycle > 0.7) {
			COLOR.rgb = vec3(1,1,1);
		}
	} else if (dead) {
		COLOR.rgb = vec3((COLOR.r + COLOR.g + COLOR.b)/3.0);
	}
}