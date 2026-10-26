#version 120

// FANGLE — conservative translucent water pass.
// No extra texture samples or render targets are used.
#ifdef MG_MOBILEGLUES
precision highp float;
precision highp int;
#endif

uniform sampler2D gtexture;
uniform sampler2D lightmap;

varying vec2 fangleTexCoord;
varying vec2 fangleLightCoord;
varying vec4 fangleVertexColor;

#define FANGLE_WATER_TINT 0.08 // [0.00 0.02 0.04 0.06 0.08 0.10 0.12 0.16 0.20]
#define FANGLE_SATURATION 1.06 // [0.90 0.95 1.00 1.05 1.10 1.15 1.20]
#define FANGLE_WARMTH 0.00 // [-0.04 -0.02 0.00 0.02 0.04]

void main() {
    vec4 albedo = texture2D(gtexture, fangleTexCoord) * fangleVertexColor;
    vec3 light = texture2D(lightmap, fangleLightCoord).rgb;
    vec3 litColor = albedo.rgb * light;

    float luminance = dot(litColor, vec3(0.299, 0.587, 0.114));
    litColor = mix(vec3(luminance), litColor, FANGLE_SATURATION);
    litColor *= vec3(1.0 + FANGLE_WARMTH, 1.0, 1.0 - FANGLE_WARMTH);

    // Restrained cool tint; preserves the sampled texture and vanilla alpha.
    vec3 coolColor = litColor * vec3(0.92, 0.99, 1.04);
    litColor = mix(litColor, coolColor, FANGLE_WATER_TINT);

    gl_FragColor = vec4(clamp(litColor, 0.0, 1.0), albedo.a);
}
