shader_type canvas_item;

uniform float scroll_speed;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 shifteduv = UV;
	shifteduv.y -= TIME * scroll_speed;
	vec4 col = texture(TEXTURE, shifteduv);
	COLOR = col;
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
