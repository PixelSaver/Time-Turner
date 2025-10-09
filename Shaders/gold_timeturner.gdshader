// Sourced from https://godotshaders.com/shader/simple-3d-metal/shader_type spatial
shader_type spatial;
render_mode specular_schlick_ggx;

uniform vec4 ColorUniform : source_color = vec4(1.0, 0.84, 0.0, 1.0);
uniform float HowShiny = 0.5; 
uniform float Roughness = 0.2; 

void fragment() {
    ALBEDO = ColorUniform.rgb;
    METALLIC = HowShiny;
    ROUGHNESS = Roughness;
	EMISSION = ColorUniform.rgb * 0.1;
}