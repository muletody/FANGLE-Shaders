#version 120

// FANGLE — alpha-tested depth pass for leaves, grass, and cutout textures.
uniform sampler2D gtexture;
varying vec2 fangleShadowTexCoord;
varying vec4 fangleShadowVertexColor;

void main() {
    vec4 texel = texture2D(gtexture, fangleShadowTexCoord) * fangleShadowVertexColor;
    if (texel.a < 0.1) {
        discard;
    }
    // Iris writes depth to shadowtex automatically.
    gl_FragColor = vec4(1.0);
}
