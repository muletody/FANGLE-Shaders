# FANGLE Shaders

**FANGLE (First-ANGLE)** is a semi-realistic Minecraft Java Edition shader pack designed around a balance of visual quality and performance on mobile GPUs, especially **Iris + MobileGlues 2.x**, optionally using ANGLE.

This branch combines the current lightweight water and color work into one coherent baseline rather than requiring several stacked feature branches. It is still an evolving shader pack, not a claim of full cinematic effects.

## Target

- Minecraft Java Edition **26.2** (target; verify exact Iris and MobileGlues versions)
- Iris shader loader
- MobileGlues 2.x, optionally using ANGLE
- OpenGL ES 3.x-class mobile hardware

## Included features

- Conservative terrain and water shader passes
- Terrain contrast control
- Color saturation control for terrain and water
- Warm/cool color balance control
- Configurable subtle cool water tint
- Optional low-amplitude water surface waves, with a zero-value off setting
- Conditional MobileGlues precision declarations
- No shadow-map render targets, screen-space passes, or extra texture samples for these effects

## Shader options

| Option | Default | Purpose |
|---|---:|---|
| `FANGLE_CONTRAST` | 1.04 | Subtle terrain contrast |
| `FANGLE_SATURATION` | 1.06 | Adjust color intensity |
| `FANGLE_WARMTH` | 0.00 | Shift warm/cool balance |
| `FANGLE_WATER_TINT` | 0.08 | Subtle cool tint on water |
| `FANGLE_WAVE_STRENGTH` | 0.005 | Low-amplitude surface motion; 0.00 disables it |

## What is not included yet

True dynamic shadows, ambient occlusion, reflections, volumetric lighting, leaf animation, held-light effects, and temporal anti-aliasing are not implemented in this baseline. These require additional compatibility work and can have a substantial performance cost on mobile.

See [PLAN.txt](PLAN.txt) and [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md) for roadmap and validation notes.

## Testing status

The user reports that the previous shader version loads and runs without errors. This consolidated branch adds color controls and bundles the water wave path; those combined changes still need in-game visual and performance validation. In particular, check that all five options appear in Iris, that wave motion only affects the water surface, and that transparency, chunk edges, and FPS remain acceptable with ANGLE on/off where possible.

The original project test environment recorded in earlier documentation was Snapdragon 778G / Adreno 642L, Android 14, Zalith Launcher 2.7.2, and MobileGlues 2.0.0. This is historical context, not a claim that this consolidated branch was tested on that setup.

## References

- [MobileGlues](https://github.com/MobileGL-Dev/MobileGlues-release)
- [Iris shader documentation](https://shaders.properties/)
- [Iris first shader pack guide](https://shaders.properties/current/guides/your-first-shaderpack/0_intro/)

## License

Distributed under the [MIT License](LICENSE).
