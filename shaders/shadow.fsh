#version 120

// FANGLE — alpha-tested depth pass for cutout textures such as leaves.
#ifdef MG_MOBILEGLUES
precision highp float;
precision highp int;
#endif

uniform sampler2D gtexture;
varying vec2 fangleShadowTexCoord;

void main() {
    vec4 texel = texture2D(gtexture, fangleShadowTexCoord);
    if (texel.a < 0.1) {
        discard;
    }
    // Depth is written by the shadow framebuffer; color output is not used.
    gl_FragColor = vec4(1.0);
}
