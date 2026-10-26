# FANGLE Shaders

**FANGLE (First-ANGLE)** is a semi-realistic Minecraft Java Edition shader pack designed around a balance of visual quality and performance on mobile GPUs, especially **Iris + MobileGlues 2.x**, optionally using ANGLE.

## Target

- Minecraft Java Edition **26.2** (target; verify exact Iris and MobileGlues versions)
- Iris shader loader
- MobileGlues 2.x, optionally using ANGLE
- OpenGL ES 3.x-class mobile hardware

## Included features

- Terrain contrast, saturation, and warm/cool balance controls
- Configurable cool water tint and low-amplitude water waves
- Initial dynamic shadow mapping for terrain using Iris shadow buffers
- Alpha-tested shadow casting for cutout textures such as leaves and grass
- Four-tap shadow-map filtering as a modest softness compromise

## Shader options

| Option | Default | Purpose |
|---|---:|---|
| `FANGLE_CONTRAST` | 1.04 | Terrain contrast |
| `FANGLE_SATURATION` | 1.06 | Color intensity |
| `FANGLE_WARMTH` | 0.00 | Warm/cool color balance |
| `FANGLE_WATER_TINT` | 0.08 | Cool tint on water |
| `FANGLE_WAVE_STRENGTH` | 0.005 | Water surface motion; zero disables it |
| `FANGLE_SHADOW_STRENGTH` | 0.65 | Shadow darkness; zero disables visible shadowing |
| `shadowMapResolution` | 1024 | Shadow map resolution |
| `shadowDistance` | 48 blocks | Shadow rendering distance |

## Compatibility and testing status

This is an initial implementation, not a verified release. The shadow pass uses Iris shader-pack conventions and requires testing with the exact Iris + MobileGlues version and ANGLE configuration. Verify that the pack compiles, terrain shadows line up correctly, leaves retain cutout holes, and the frame rate remains acceptable. The current shadow sampling is applied in the terrain fragment shader; entities, translucent objects, and some special render passes are not yet guaranteed to receive shadows.

See [PLAN.txt](PLAN.txt) and [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md) for the validation checklist.

## References

- [MobileGlues](https://github.com/MobileGL-Dev/MobileGlues-release)
- [Iris shader documentation](https://shaders.properties/)
- [Iris shadow mapping guide](https://shaders.properties/current/guides/your-first-shaderpack/4_shadows/)

## License

Distributed under the [MIT License](LICENSE).
