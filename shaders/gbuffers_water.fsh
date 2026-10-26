#version 120

// FANGLE — conservative translucent water pass.
// The tint is intentionally inexpensive: no extra samples or render targets.
#ifdef MG_MOBILEGLUES
precision highp float;
precision highp int;
#endif

uniform sampler2D gtexture;
uniform sampler2D lightmap;

varying vec2 fangleTexCoord;
varying vec2 fangleLightCoord;
varying vec4 fangleVertexColor;

// 0.00 keeps the texture unchanged; higher values add a restrained cool tint.
#define FANGLE_WATER_TINT 0.08 // [0.00 0.02 0.04 0.06 0.08 0.10 0.12 0.16 0.20]

void main() {
    vec4 albedo = texture2D(gtexture, fangleTexCoord) * fangleVertexColor;
    vec3 light = texture2D(lightmap, fangleLightCoord).rgb;
    vec3 litColor = albedo.rgb * light;

    // A subtle cool shift, preserving the sampled texture and vanilla alpha.
    vec3 coolColor = litColor * vec3(0.92, 0.99, 1.04);
    litColor = mix(litColor, coolColor, FANGLE_WATER_TINT);

    gl_FragColor = vec4(clamp(litColor, 0.0, 1.0), albedo.a);
}
