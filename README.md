# FANGLE Shaders

**FANGLE (First-ANGLE)** is a semi-realistic shader pack for Minecraft Java Edition, developed with mobile GPUs and **MobileGlues + Iris** in mind. ANGLE is an optional graphics-driver path in MobileGlues and should be tested on the target device.

The project prioritizes stable rendering and practical frame rates before expensive effects. It is under active development; the current branch contains an initial terrain/water baseline, not a finished feature-complete shader pack.

## Current target

- Minecraft Java Edition **26.2** (target; verify compatibility with the exact Iris and MobileGlues builds)
- Iris shader loader
- MobileGlues 2.x, optionally using ANGLE
- OpenGL ES 3.x class hardware

## Current implementation

- Conservative terrain vertex/fragment pass
- Conservative water pass without reflections or wave displacement
- One low-cost terrain contrast option
- Conditional MobileGlues precision declarations

## Planned features

See [PLAN.txt](PLAN.txt) for the feature list and [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md) for development and validation notes.

- Adjustable shadow distance and quality
- Optional shadow filtering
- Held torch/lantern lighting
- FXAA first; TAA only after a reliable multi-pass history path exists
- Leaf and water-wave animation
- Enhanced and Realistic water modes

## Testing status

The project has **not yet been validated in-game** on the target Minecraft/Iris/MobileGlues combination. A successful shader compile and correct rendering must be verified on a real device before features are considered complete.

The original development test environment was a Snapdragon 778G / Adreno 642L device running Android 14, Zalith Launcher 2.7.2, and MobileGlues 2.0.0. This is historical project context, not a claim that the current code has been tested there.

## References

- [MobileGlues](https://github.com/MobileGL-Dev/MobileGlues-release)
- [Iris shader documentation](https://shaders.properties/)
- [Iris: first shader pack guide](https://shaders.properties/current/guides/your-first-shaderpack/0_intro/)

## License

Distributed under the [MIT License](LICENSE).
