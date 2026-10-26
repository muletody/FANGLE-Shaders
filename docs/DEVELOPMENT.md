# FANGLE development notes

## Target

- Minecraft Java Edition 26.2 (test target; verify the exact Iris build in use)
- Iris shader loader
- MobileGlues 2.x, optionally using ANGLE
- OpenGL ES 3.x-class hardware

## Compatibility rules

1. Prefer simple GLSL and avoid desktop-only extensions.
2. Keep MobileGlues precision declarations conditional on `MG_MOBILEGLUES`.
3. Keep shadow-map resolution modest by default and avoid unnecessary render targets.
4. Put expensive effects behind options and profile them on the target device.
5. Treat successful loading, visual correctness, translucent rendering, and frame time as separate test gates.

## Shadow implementation

The shadow pass writes depth to Iris-managed shadow buffers. The terrain vertex shader transforms each vertex into shadow space using `gbufferModelViewInverse`, `shadowModelView`, and `shadowProjection`. The terrain fragment shader compares that coordinate with `shadowtex0` using four nearby samples and a small depth bias. The shadow fragment shader alpha-tests the sampled block texture so foliage cutouts do not cast fully solid rectangular shadows.

Defaults are intentionally conservative: a 1024 shadow map, 48-block shadow distance, and 0.65 shadow strength. These are starting values and have not yet been verified on a physical device. The current receiver is terrain; shadow reception on entities and translucent geometry is not promised.

## Validation checklist

1. Confirm the pack loads without GLSL compile/link errors on the target Iris + MobileGlues build.
2. Confirm all options appear in the Iris shader settings.
3. Check shadow direction, projection alignment, acne, peter-panning, and frustum edges while rotating the camera.
4. Inspect leaves and grass to ensure alpha cutouts survive in the shadow map.
5. Check water transparency and wave behavior remain unchanged.
6. Compare FPS at 512, 1024, and 2048 shadow-map resolutions if the controls are available.
7. Test with ANGLE enabled and disabled where possible and record logs plus FPS.
