shader_type spatial;

uniform sampler2D uv_mask_texture: source_color, hint_default_black;
uniform vec3 fingerprint_color: source_color = vec3(1);
uniform float fingerprint_color_intensity = 50.0;


const float GROW = 0.0001;
void vertex() {
	VERTEX += NORMAL * GROW;
}

void fragment() {
	ALPHA = 0.0;
}

void light() {
	float light_value = clamp(dot(LIGHT, NORMAL), 0, 1) * ATTENUATION;
	vec3 light_color = LIGHT_COLOR / PI;
	
	vec3 diffuse_contribution = light_value * light_color;
	
	float uv_mask = texture(uv_mask_texture, UV).r;
	DIFFUSE_LIGHT += diffuse_contribution * fingerprint_color * uv_mask * fingerprint_color_intensity;
	
	float transparency_value = uv_mask * length(diffuse_contribution);
	ALPHA += transparency_value;
	ALPHA = clamp(ALPHA, 0, 1);
}
