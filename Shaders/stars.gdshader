shader_type spatial;
render_mode unshaded;
vec3 palette( float t ) {
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.263, 0.410, 0.557);
    
    return a + b*cos( 6.28318 * (c*t+d) );
}
float g(vec2 p) {
    float theta = atan(p.y, p.x);
    float r = length(p);
    return r - tan(theta * (TIME+100.));
}
float cool(vec2 p, float mult) {
    return p.y - (sin(p.x * cos(p.y))*cos((TIME+100.))*5. + sin((TIME+100.)) * mult);
}
void fragment()
{
    vec2 resolution = vec2(1.0);
    vec2 uv = (UV * 2.0 - 1.0);
    uv.x *= resolution.x / resolution.y;

    // Quantize UV for larger stars
    float pixel_size = 150.0; 
    uv = floor(uv * pixel_size) / pixel_size;

    float val = cool(uv*100., 3.);
    float d = abs(val);
    float cool_line = smoothstep(0.8, 0.1, d);

    vec2 new_uv = vec2(uv.x, uv.y);
    val = -abs(cool(new_uv*10., -3.));
    cool_line += smoothstep(0.8, 0.1, d);

    float val2 = g(uv*100.);
    float d2 = abs(val2);

    float g_line = smoothstep(0.9, 0.2, d2);
    cool_line += g_line;

    // Simulated glow for visibility
    float glow = exp(-20.0 * d2);
    vec3 color = vec3(g_line + glow * 0.5);

    ALBEDO = color;
    EMISSION = color * 2.0;
}
