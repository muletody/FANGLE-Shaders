# FANGLE development notes

## Target

- Minecraft Java Edition 26.2 (test target; verify the exact Iris build in use)
- Iris shader loader
- MobileGlues 2.x, optionally using ANGLE
- OpenGL ES 3.x-class hardware

## Compatibility rules

1. Prefer simple GLSL and avoid desktop-only extensions.
2. Keep MobileGlues precision declarations conditional on `MG_MOBILEGLUES`, so ordinary desktop GLSL 1.20 parsers do not see ES-only precision statements.
3. Avoid compute shaders, SSBOs, image load/store, and extra render targets in the mobile baseline.
4. Put expensive effects behind options and profile them on the target device.
5. Treat successful loading, visual correctness, translucent rendering, and frame time as separate test gates.

## Current baseline

The consolidated branch includes terrain contrast, saturation, warm/cool color balance, a configurable water tint, and low-amplitude water waves. Color controls use arithmetic on the already sampled texture and lightmap; they do not add texture reads or render targets. The water vertex stage uses `frameTimeCounter` and only displaces vertices whose `gl_Normal.y` is greater than 0.5.

## Validation checklist

1. Confirm the pack loads and terrain, foliage, entities, hand, and translucent blocks render correctly.
2. Confirm all five options appear in the Iris shader settings.
3. Test saturation/warmth at neutral settings and extremes; verify alpha is unchanged.
4. Compare wave strength 0.00 and 0.005, and inspect water sides, chunk borders, and underwater views.
5. Compare FPS and visual quality with ANGLE enabled and disabled where possible.
6. Add shadow mapping only after this baseline is stable; start with a small shadow map and profile it before increasing quality.
7. Do not animate foliage by moving all terrain vertices; first establish a reliable foliage-only identification path.
8. Treat FXAA as a possible later low-cost post-process; TAA and reflections need additional passes and careful performance testing.
