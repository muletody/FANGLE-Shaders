# FANGLE development notes

## Target

- Minecraft Java Edition 26.2 (test target; verify the exact Iris build in use)
- Iris shader loader
- MobileGlues 2.x, optionally using ANGLE
- OpenGL ES 3.x class hardware

## Compatibility rules

1. Prefer simple GLSL and avoid desktop-only extensions.
2. Keep MobileGlues precision declarations conditional on `MG_MOBILEGLUES`, so ordinary desktop GLSL 1.20 parsers do not see ES-only precision statements.
3. Avoid compute shaders, SSBOs, image load/store, and extra render targets in the baseline.
4. Add expensive features behind options and profile each one on the target device.
5. Treat successful loading, terrain correctness, translucent rendering, and frame time as separate test gates.

## Current milestone: baseline terrain

The first implementation adds a conservative terrain vertex/fragment pair and one low-cost contrast control. It is a starting point, not a completed shader pack. It has not yet been compiled or tested inside Minecraft; validate it with MobileGlues logs before adding water animation or shadow mapping.

## Planned sequence

1. Confirm the pack loads and terrain, foliage, entities, hand, and translucent blocks render correctly.
2. Add shader options and low-cost color grading.
3. Add leaf animation and water waves behind independent sliders.
4. Add shadow mapping with a small default map and configurable quality/distance.
5. Add held-light approximation if the loader exposes the required uniforms reliably.
6. Evaluate FXAA; treat TAA as a later feature because temporal history requires extra passes and validation.
7. Add enhanced/realistic water as progressively more expensive presets.
