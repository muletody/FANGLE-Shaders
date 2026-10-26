#version 120

// FANGLE — water vertex stage with optional low-amplitude waves.
#ifdef MG_MOBILEGLUES
precision highp float;
precision highp int;
#endif

uniform float frameTimeCounter;

varying vec2 fangleTexCoord;
varying vec2 fangleLightCoord;
varying vec4 fangleVertexColor;

// Keep displacement tiny for mobile performance and stable transparency.
#define FANGLE_WAVE_STRENGTH 0.005 // [0.00 0.005 0.01 0.015 0.02]

void main() {
    vec4 waterVertex = gl_Vertex;

    // Animate upward-facing surface vertices only; 0.00 disables movement.
    if (gl_Normal.y > 0.5) {
        float wavePhase = (gl_Vertex.x + gl_Vertex.z) * 0.3926991 + frameTimeCounter * 1.2;
        waterVertex.y += sin(wavePhase) * FANGLE_WAVE_STRENGTH;
    }

    gl_Position = gl_ModelViewProjectionMatrix * waterVertex;
    fangleTexCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    fangleLightCoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    fangleVertexColor = gl_Color;
}
