#version 120

// FANGLE — mobile-first terrain fragment pass with dynamic shadows.
#ifdef MG_MOBILEGLUES
precision highp float;
precision highp int;
#endif

#include "/lib/settings.glsl"

uniform sampler2D gtexture;
uniform sampler2D lightmap;
// shadowtex1 holds opaque geometry only, so translucent water and glass do not cast solid shadows.
uniform sampler2D shadowtex1;

varying vec2 fangleTexCoord;
varying vec2 fangleLightCoord;
varying vec4 fangleVertexColor;
varying vec3 fangleShadowCoord;
varying float fangleNdotL;

// Iris shader options: start with a small shadow map for mobile GPUs.
const int shadowMapResolution = 1024; // [512 1024 1536 2048]
const float shadowDistance = 48.0; // [32.0 48.0 64.0 96.0]

float fangleGetShadow(vec3 shadowPos, float ndotl) {
    // Outside the light frustum is treated as lit.
    if (shadowPos.x <= 0.001 || shadowPos.x >= 0.999 ||
        shadowPos.y <= 0.001 || shadowPos.y >= 0.999 ||
        shadowPos.z <= 0.001 || shadowPos.z >= 0.999) {
        return 1.0;
    }

    // The bias follows the shadow texel size (distance / resolution), so it adapts to both
    // sliders. 0.0256 * 48 / 1024 = 0.0012, the previous fixed bias at default settings.
    // Surfaces at a grazing angle to the light get a larger bias to avoid acne.
    float baseBias = 0.0256 * shadowDistance / float(shadowMapResolution);
    float cosTheta = clamp(ndotl, 0.1, 1.0);
    float slope = sqrt(1.0 - cosTheta * cosTheta) / cosTheta;
    float bias = baseBias * (1.0 + min(slope, 3.0));

    // Four taps soften aliasing cheaply.
    vec2 texel = vec2(1.0 / float(shadowMapResolution));
    float visibility = 0.0;
    visibility += step(shadowPos.z - bias, texture2D(shadowtex1, shadowPos.xy + texel * vec2(-0.5, -0.5)).r);
    visibility += step(shadowPos.z - bias, texture2D(shadowtex1, shadowPos.xy + texel * vec2( 0.5, -0.5)).r);
    visibility += step(shadowPos.z - bias, texture2D(shadowtex1, shadowPos.xy + texel * vec2(-0.5,  0.5)).r);
    visibility += step(shadowPos.z - bias, texture2D(shadowtex1, shadowPos.xy + texel * vec2( 0.5,  0.5)).r);
    return visibility * 0.25;
}

void main() {
    vec4 albedo = texture2D(gtexture, fangleTexCoord) * fangleVertexColor;
    vec3 light = texture2D(lightmap, fangleLightCoord).rgb;
    vec3 litColor = albedo.rgb * light;

    float shadowVisibility = fangleGetShadow(fangleShadowCoord, fangleNdotL);
    // Faces turned away from the light are in shadow even when nothing occludes them in the map.
    shadowVisibility *= smoothstep(0.0, 0.15, fangleNdotL);

    // Shadows only dim sky light: caves, interiors and torch-lit areas are left alone.
    // The thresholds are a starting point and may need tuning in game.
    float skyMask = smoothstep(0.35, 0.9, fangleLightCoord.y);
    float shadowFactor = mix(1.0, mix(1.0 - FANGLE_SHADOW_STRENGTH, 1.0, shadowVisibility), skyMask);
    litColor *= shadowFactor;

    litColor = (litColor - vec3(0.5)) * FANGLE_CONTRAST + vec3(0.5);
    float luminance = dot(litColor, vec3(0.299, 0.587, 0.114));
    litColor = mix(vec3(luminance), litColor, FANGLE_SATURATION);
    litColor *= vec3(1.0 + FANGLE_WARMTH, 1.0, 1.0 - FANGLE_WARMTH);
    litColor = clamp(litColor, 0.0, 1.0);

    gl_FragColor = vec4(litColor, albedo.a);
}
