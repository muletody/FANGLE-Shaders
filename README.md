# GLES Shaders

A semi-realistic Minecraft Java Edition shader pack built for mobile GPUs. It runs on **Iris + MobileGlues 2.x using the device's native GLES driver (no ANGLE)** and aims for a balance between visual quality and frame rate.

> **Status: in development.** This pack has not been verified as a release. It was written against the Iris shader-pack conventions and still needs testing on real devices. See [Compatibility and testing status](#compatibility-and-testing-status).
>
> *Formerly called FANGLE. Some option names and code identifiers still use the `FANGLE_` prefix.*

## Requirements

| Component | Requirement |
|---|---|
| Game | Minecraft Java Edition **26.2** (target; verify against your exact Iris build) |
| Shader loader | Iris |
| Renderer | MobileGlues 2.x with the **native GLES driver** |
| ANGLE | **Not used.** Turn it off explicitly in the MobileGlues settings; its default policy may still enable it on some GPUs |
| Hardware | OpenGL ES 3.x-class mobile GPU. Primary test GPU: Adreno |

## Installation

1. Put the `shaders` folder of this repository inside a new folder in your game's `shaderpacks` directory, for example `shaderpacks/GLES-Shaders/shaders/`. A `.zip` also works if `shaders/` is at the root of the archive.
2. Start the game with Iris and MobileGlues, with ANGLE turned off.
3. Open the Iris shader settings and select **GLES-Shaders**.

The location of the game directory depends on your launcher.

## Features

- **Terrain color controls:** contrast, saturation, and warm/cool balance.
- **Water:** configurable cool tint and low-amplitude waves that stay anchored to the world.
- **Dynamic terrain shadows** from the Iris shadow buffers:
  - Shadows only dim sky light, so caves and torch-lit areas are not darkened twice.
  - Faces turned away from the sun or moon are shaded, and the depth bias adapts to the shadow-map settings and surface angle.
  - Four-tap filtering as a cheap softness compromise.
- **Cutout-aware shadow casting:** leaves and grass keep their holes in the shadow map.
- **No solid water or glass shadows:** shadows are sampled from opaque geometry only.

## Shader options

Defaults live in [`shaders/lib/settings.glsl`](shaders/lib/settings.glsl), except the two shadow-map constants, which are in `shaders/gbuffers_terrain.fsh`. All options appear in the Iris shader settings screen.

| Option | Default | Range | Purpose |
|---|---:|---|---|
| `FANGLE_CONTRAST` | 1.04 | 1.00 to 1.06 | Terrain contrast |
| `FANGLE_SATURATION` | 1.06 | 0.90 to 1.20 | Color intensity |
| `FANGLE_WARMTH` | 0.00 | -0.04 to 0.04 | Warm/cool color balance |
| `FANGLE_WATER_TINT` | 0.08 | 0.00 to 0.20 | Cool tint on water |
| `FANGLE_WAVE_STRENGTH` | 0.005 | 0.00 to 0.02 | Water surface motion; zero disables it |
| `FANGLE_SHADOW_STRENGTH` | 0.65 | 0.00 to 1.00 | Shadow darkness; zero disables visible shadowing |
| `shadowMapResolution` | 1024 | 512 to 2048 | Shadow map resolution |
| `shadowDistance` | 48 | 32 to 96 blocks | Shadow rendering distance |

### Tuning for performance

Shadows are the most expensive feature. If the frame rate is low, lower `shadowMapResolution` and `shadowDistance` first, or set `FANGLE_SHADOW_STRENGTH` to `0.00`.

## Compatibility and testing status

This is an initial implementation, not a verified release. It still needs to be checked on the exact Iris and MobileGlues versions and on the target GPU. In particular:

- The pack loads without shader compile or link errors.
- Terrain shadows line up with the sun at different camera angles and times of day.
- Leaves and grass keep their cutouts.
- Entities and the held item render correctly with ANGLE off.
- The frame rate is acceptable with shadows on.

### Known limitations

- Shadows are received by terrain only. Entities, translucent blocks, and some special render passes are not guaranteed to receive them.
- There is no fog, so the edge of the render distance may be visible.
- Color grading is applied to terrain and water only. Entities, the hand, and the sky use the Iris defaults.
- No foliage animation, held-light support, or anti-aliasing yet.

### Reporting test results

When you report a problem or a result, please include:

- Device, GPU model, and Android version
- Minecraft, Iris, and MobileGlues versions
- Whether ANGLE was off
- The relevant log lines and, if possible, a screenshot
- Frame rate with shadows on and off

## Project documents

- [PLAN.txt](PLAN.txt): implementation plan and validation gates
- [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md): development notes and test checklist

## References

- [MobileGlues](https://github.com/MobileGL-Dev/MobileGlues-release)
- [Iris shader documentation](https://shaders.properties/)
- [Iris shadow mapping guide](https://shaders.properties/current/guides/your-first-shaderpack/4_shadows/)

## License

Released under the MIT License.
