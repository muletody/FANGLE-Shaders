#version 120

// FANGLE — mobile-first terrain fragment pass.
// No shadow maps, extra render targets, or screen-space passes are required.
#ifdef MG_MOBILEGLUES
precision highp float;
precision highp int;
#endif

uniform sampler2D gtexture;
uniform sampler2D lightmap;

varying vec2 fangleTexCoord;
varying vec2 fangleLightCoord;
varying vec4 fangleVertexColor;

// Low-cost color controls; all defaults are intentionally restrained.
#define FANGLE_CONTRAST 1.04 // [1.00 1.01 1.02 1.03 1.04 1.05 1.06]
#define FANGLE_SATURATION 1.06 // [0.90 0.95 1.00 1.05 1.10 1.15 1.20]
#define FANGLE_WARMTH 0.00 // [-0.04 -0.02 0.00 0.02 0.04]

void main() {
    vec4 albedo = texture2D(gtexture, fangleTexCoord) * fangleVertexColor;
    vec3 light = texture2D(lightmap, fangleLightCoord).rgb;
    vec3 litColor = albedo.rgb * light;

    // Contrast centered around mid-gray.
    litColor = (litColor - vec3(0.5)) * FANGLE_CONTRAST + vec3(0.5);

    // Adjust saturation without changing alpha or sampling additional textures.
    float luminance = dot(litColor, vec3(0.299, 0.587, 0.114));
    litColor = mix(vec3(luminance), litColor, FANGLE_SATURATION);

    // Small warm/cool balance; zero is neutral.
    litColor *= vec3(1.0 + FANGLE_WARMTH, 1.0, 1.0 - FANGLE_WARMTH);
    litColor = clamp(litColor, 0.0, 1.0);

    gl_FragColor = vec4(litColor, albedo.a);
}
