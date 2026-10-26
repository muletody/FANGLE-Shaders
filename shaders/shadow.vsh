#version 120

// FANGLE — minimal shadow-map vertex pass.
#ifdef MG_MOBILEGLUES
precision highp float;
precision highp int;
#endif

uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

varying vec2 fangleShadowTexCoord;

void main() {
    gl_Position = shadowProjection * shadowModelView * gl_ModelViewMatrix * gl_Vertex;
    fangleShadowTexCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
}
