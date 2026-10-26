# FANGLE Shaders

**FANGLE (First-ANGLE)** is a semi-realistic shader pack for Minecraft Java Edition, developed with mobile GPUs and **MobileGlues + Iris** in mind. ANGLE is an optional graphics-driver path in MobileGlues and should be tested on the target device.

The project prioritizes stable rendering and practical frame rates before expensive effects. The current development branch adds a low-amplitude water wave control on top of the terrain/water baseline.

## Current target

- Minecraft Java Edition **26.2** (target; verify compatibility with the exact Iris and MobileGlues builds)
- Iris shader loader
- MobileGlues 2.x, optionally using ANGLE
- OpenGL ES 3.x class hardware

## Current implementation

- Conservative terrain vertex/fragment pass
- Conservative water pass with configurable low-amplitude vertical waves
- Low-cost terrain contrast slider
- Configurable, subtle cool water tint slider (no extra texture samples or render targets)
- Water wave strength slider, default 0.005; set to 0.00 to disable
- Conditional MobileGlues precision declarations

## Planned features

See [PLAN.txt](PLAN.txt) for the feature list and [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md) for development and validation notes.

- Adjustable shadow distance and quality
- Optional shadow filtering
- Held torch/lantern lighting
- FXAA first; TAA only after a reliable multi-pass history path exists
- Leaf animation
- Enhanced and Realistic water modes

## Testing status

The shader pack loaded without reported errors in the user's initial test. The new wave animation has not yet been verified in-game: check whether the slider appears, whether water surfaces move smoothly, whether chunk edges show seams, and whether performance remains stable. The tint and wave effects should be validated on the target Minecraft/Iris/MobileGlues setup, including ANGLE if available.

The original development test environment was a Snapdragon 778G / Adreno 642L device running Android 14, Zalith Launcher 2.7.2, and MobileGlues 2.0.0. This is historical project context, not a claim that the current code has been tested there.

## References

- [MobileGlues](https://github.com/MobileGL-Dev/MobileGlues-release)
- [Iris shader documentation](https://shaders.properties/)
- [Iris: first shader pack guide](https://shaders.properties/current/guides/your-first-shaderpack/0_intro/)

## License

Distributed under the [MIT License](LICENSE).
