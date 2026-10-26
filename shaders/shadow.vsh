#version 120

// FANGLE — lightweight shadow-map caster pass.
varying vec2 fangleShadowTexCoord;
varying vec4 fangleShadowVertexColor;

void main() {
    gl_Position = ftransform();
    fangleShadowTexCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    fangleShadowVertexColor = gl_Color;
}
