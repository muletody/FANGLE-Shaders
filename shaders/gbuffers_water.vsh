#version 120

// Water currently uses a stable, non-animated vertex path.
// Wave displacement will be introduced after the terrain baseline is verified.
#ifdef MG_MOBILEGLUES
precision highp float;
precision highp int;
#endif

varying vec2 fangleTexCoord;
varying vec2 fangleLightCoord;
varying vec4 fangleVertexColor;

void main() {
    gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
    fangleTexCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    fangleLightCoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    fangleVertexColor = gl_Color;
}
