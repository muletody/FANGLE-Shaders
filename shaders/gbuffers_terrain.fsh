#version 120

// FANGLE — first terrain fragment pass.
// No shadow maps, extra render targets, or screen-space passes are required yet.
#ifdef MG_MOBILEGLUES
precision highp float;
precision highp int;
#endif

uniform sampler2D gtexture;
uniform sampler2D lightmap;

varying vec2 fangleTexCoord;
varying vec2 fangleLightCoord;
varying vec4 fangleVertexColor;

// Slightly increase local contrast without adding an expensive post-process.
#define FANGLE_CONTRAST 1.04 // [1.00 1.01 1.02 1.03 1.04 1.05 1.06]

void main() {
    vec4 albedo = texture2D(gtexture, fangleTexCoord) * fangleVertexColor;
    vec3 light = texture2D(lightmap, fangleLightCoord).rgb;
    vec3 litColor = albedo.rgb * light;

    // Mild contrast centered around mid-gray; preserve the vanilla lightmap.
    litColor = (litColor - vec3(0.5)) * FANGLE_CONTRAST + vec3(0.5);
    litColor = clamp(litColor, 0.0, 1.0);

    gl_FragColor = vec4(litColor, albedo.a);
}
