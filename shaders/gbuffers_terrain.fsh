#version 120

// FANGLE — mobile-first terrain fragment pass with dynamic shadows.
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

// Iris shader options: start with a small shadow map for mobile GPUs.
const int shadowMapResolution = 1024; // [512 1024 1536 2048]
const float shadowDistance = 48.0; // [32.0 48.0 64.0 96.0]
#define FANGLE_CONTRAST 1.04 // [1.00 1.01 1.02 1.03 1.04 1.05 1.06]
#define FANGLE_SATURATION 1.06 // [0.90 0.95 1.00 1.05 1.10 1.15 1.20]
#define FANGLE_WARMTH 0.00 // [-0.04 -0.02 0.00 0.02 0.04]
#define FANGLE_SHADOW_STRENGTH 0.65 // [0.00 0.25 0.50 0.65 0.80 1.00]

float fangleGetShadow(vec3 shadowPos) {
    // Outside the light frustum is treated as lit.
    if (shadowPos.x <= 0.001 || shadowPos.x >= 0.999 ||
        shadowPos.y <= 0.001 || shadowPos.y >= 0.999 ||
        shadowPos.z <= 0.001 || shadowPos.z >= 0.999) {
        return 1.0;
    }

    // Small depth bias reduces self-shadowing. Four taps soften aliasing cheaply.
    float bias = 0.0012;
    vec2 texel = vec2(1.0 / float(shadowMapResolution));
    float visibility = 0.0;
    visibility += step(shadowPos.z - bias, texture2D(shadowtex0, shadowPos.xy + texel * vec2(-0.5, -0.5)).r);
    visibility += step(shadowPos.z - bias, texture2D(shadowtex0, shadowPos.xy + texel * vec2( 0.5, -0.5)).r);
    visibility += step(shadowPos.z - bias, texture2D(shadowtex0, shadowPos.xy + texel * vec2(-0.5,  0.5)).r);
    visibility += step(shadowPos.z - bias, texture2D(shadowtex0, shadowPos.xy + texel * vec2( 0.5,  0.5)).r);
    return visibility * 0.25;
}

void main() {
    vec4 albedo = texture2D(gtexture, fangleTexCoord) * fangleVertexColor;
    vec3 light = texture2D(lightmap, fangleLightCoord).rgb;
    vec3 litColor = albedo.rgb * light;

    float shadowVisibility = fangleGetShadow(fangleShadowCoord);
    float shadowFactor = mix(1.0 - FANGLE_SHADOW_STRENGTH, 1.0, shadowVisibility);
    litColor *= shadowFactor;

    litColor = (litColor - vec3(0.5)) * FANGLE_CONTRAST + vec3(0.5);
    float luminance = dot(litColor, vec3(0.299, 0.587, 0.114));
    litColor = mix(vec3(luminance), litColor, FANGLE_SATURATION);
    litColor *= vec3(1.0 + FANGLE_WARMTH, 1.0, 1.0 - FANGLE_WARMTH);
    litColor = clamp(litColor, 0.0, 1.0);

    gl_FragColor = vec4(litColor, albedo.a);
}
