shader_type canvas_item;

uniform float glow_intensity : hint_range(0.0, 10.0) = 0.0;
uniform vec4 glow_color : source_color = vec4(1.0, 0.9, 0.4, 1.0);
uniform float glow_width : hint_range(0.0, 20.0) = 6.0; // Más rango de grosor

void fragment() {
	vec4 original_color = texture(TEXTURE, UV);
	
	// Multiplicamos el tamaño del píxel para "engordar" el efecto artificialmente
	vec2 ps = TEXTURE_PIXEL_SIZE * 1.5; 
	float alpha_acumulado = 0.0;
	
	// Muestreamos en 8 direcciones alrededor del píxel para un halo más gordo
	for(float i = 1.0; i <= glow_width; i += 1.0) {
		alpha_acumulado += texture(TEXTURE, UV + vec2(0.0, ps.y * i)).a;
		alpha_acumulado += texture(TEXTURE, UV + vec2(0.0, -ps.y * i)).a;
		alpha_acumulado += texture(TEXTURE, UV + vec2(ps.x * i, 0.0)).a;
		alpha_acumulado += texture(TEXTURE, UV + vec2(-ps.x * i, 0.0)).a;
		// Diagonales (NUEVO)
		alpha_acumulado += texture(TEXTURE, UV + vec2(ps.x * i, ps.y * i) * 0.7).a;
		alpha_acumulado += texture(TEXTURE, UV + vec2(-ps.x * i, -ps.y * i) * 0.7).a;
		alpha_acumulado += texture(TEXTURE, UV + vec2(ps.x * i, -ps.y * i) * 0.7).a;
		alpha_acumulado += texture(TEXTURE, UV + vec2(-ps.x * i, ps.y * i) * 0.7).a;
	}
	
	// Calculamos el factor de brillo exterior puro
	float halo = clamp(alpha_acumulado / (glow_width * 8.0), 0.0, 1.0);
	float factor_brillo = halo * (1.0 - original_color.a) * glow_intensity;
	
	// Si es el dibujo original, mantiene su color. Si es el borde vacío, dibuja el neón puro
	vec3 rgb_final = mix(glow_color.rgb, original_color.rgb, original_color.a);
	float alpha_final = clamp(original_color.a + factor_brillo, 0.0, 1.0);
	
	COLOR = vec4(rgb_final, alpha_final);
}