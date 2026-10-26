#version 120

// FANGLE — conservative translucent water pass.
// Reflections and animated normals are intentionally deferred.
#ifdef MG_MOBILEGLUES
precision highp float;
precision highp int;
#endif

uniform sampler2D gtexture;
uniform sampler2D lightmap;

varying vec2 fangleTexCoord;
varying vec2 fangleLightCoord;
varying vec4 fangleVertexColor;

void main() {
    vec4 albedo = texture2D(gtexture, fangleTexCoord) * fangleVertexColor;
    vec3 light = texture2D(lightmap, fangleLightCoord).rgb;
    gl_FragColor = vec4(albedo.rgb * light, albedo.a);
}
