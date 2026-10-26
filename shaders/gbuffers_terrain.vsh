#version 120

// FANGLE — terrain vertex stage with shadow-space coordinates.
#ifdef MG_MOBILEGLUES
precision highp float;
precision highp int;
#endif

uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

varying vec2 fangleTexCoord;
varying vec2 fangleLightCoord;
varying vec4 fangleVertexColor;
varying vec3 fangleShadowCoord;

void main() {
    vec4 viewPos = gl_ModelViewMatrix * gl_Vertex;
    vec4 playerPos = gbufferModelViewInverse * viewPos;
    vec4 shadowClipPos = shadowProjection * shadowModelView * playerPos;
    fangleShadowCoord = (shadowClipPos.xyz / shadowClipPos.w) * 0.5 + 0.5;

    gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
    fangleTexCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    fangleLightCoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    fangleVertexColor = gl_Color;
}
