#version 120

// FANGLE — water vertex stage with optional low-amplitude waves.
#include "/lib/settings.glsl"

uniform float frameTimeCounter;
uniform mat4 gbufferModelViewInverse;
uniform vec3 cameraPosition;

varying vec2 fangleTexCoord;
varying vec2 fangleLightCoord;
varying vec4 fangleVertexColor;

void main() {
    vec4 waterVertex = gl_Vertex;

    // Animate upward-facing surface vertices only; 0.00 disables movement.
    if (gl_Normal.y > 0.5) {
        // Use world-space position so the waves stay anchored to the world instead of
        // sliding with the camera (gl_Vertex is camera-relative in Iris).
        vec3 worldPos = (gbufferModelViewInverse * (gl_ModelViewMatrix * gl_Vertex)).xyz + cameraPosition;

        // The wavelength is 16 blocks (2*pi / 0.3926991), so wrapping the coordinate keeps
        // the phase seamless and avoids float precision loss far from the origin.
        float wavePhase = mod(worldPos.x + worldPos.z, 16.0) * 0.3926991 + frameTimeCounter * 1.2;
        waterVertex.y += sin(wavePhase) * FANGLE_WAVE_STRENGTH;
    }

    gl_Position = gl_ModelViewProjectionMatrix * waterVertex;
    fangleTexCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    fangleLightCoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    fangleVertexColor = gl_Color;
}
