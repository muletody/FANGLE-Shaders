#version 120

// FANGLE — mobile-first terrain fragment pass with experimental shadows.
#ifdef MG_MOBILEGLUES
precision highp float;
precision highp int;
#endif

uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform sampler2D shadowtex0;

varying vec2 fangleTexCoord;
varying vec2 fangleLightCoord;
varying vec4 fangleVertexColor;
varying vec3 fangleShadowCoord;

#define FANGLE_CONTRAST 1.04 // [1.00 1.01 1.02 1.03 1.04 1.05 1.06]
#define FANGLE_SATURATION 1.06 // [0.90 0.95 1.00 1.05 1.10 1.15 1.20]
#define FANGLE_WARMTH 0.00 // [-0.04 -0.02 0.00 0.02 0.04]
#define FANGLE_SHADOW_STRENGTH 0.45 // [0.00 0.15 0.30 0.45 0.60 0.75]

float fangleShadowVisibility(vec3 coord) {
    if (coord.x <= 0.001 || coord.x >= 0.999 ||
        coord.y <= 0.001 || coord.y >= 0.999 ||
        coord.z <= 0.001 || coord.z >= 0.999) {
        return 1.0;
    }
    float storedDepth = texture2D(shadowtex0, coord.xy).r;
    float bias = 0.0015;
    return (coord.z - bias > storedDepth) ? 0.55 : 1.0;
}

void main() {
    vec4 albedo = texture2D(gtexture, fangleTexCoord) * fangleVertexColor;
    vec3 light = texture2D(lightmap, fangleLightCoord).rgb;
    vec3 litColor = albedo.rgb * light;

    litColor = (litColor - vec3(0.5)) * FANGLE_CONTRAST + vec3(0.5);
    float luminance = dot(litColor, vec3(0.299, 0.587, 0.114));
    litColor = mix(vec3(luminance), litColor, FANGLE_SATURATION);
    litColor *= vec3(1.0 + FANGLE_WARMTH, 1.0, 1.0 - FANGLE_WARMTH);

    float shadowVisibility = fangleShadowVisibility(fangleShadowCoord);
    litColor *= mix(1.0, shadowVisibility, clamp(FANGLE_SHADOW_STRENGTH / 0.45, 0.0, 1.0));
    litColor = clamp(litColor, 0.0, 1.0);

    gl_FragColor = vec4(litColor, albedo.a);
}
