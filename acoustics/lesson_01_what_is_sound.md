# Lesson 1 — What Is Sound?

## The Physical Picture

Start with a room full of air. At rest, air molecules are distributed roughly uniformly and the pressure everywhere is atmospheric (~101 kPa). When something vibrates — a speaker cone, a vocal cord, your hands clapping — it pushes on the air immediately next to it. That push locally compresses the air, raising pressure slightly above ambient.

That compressed region doesn't just sit there. The higher-pressure air pushes outward on its neighbors, which compress, which push on *their* neighbors — and so the disturbance propagates. Behind the initial compression, the source has already moved back, leaving a rarefaction (pressure below ambient). What you get is an alternating pattern of compressions and rarefactions rippling outward through the medium.

The crucial point: **the molecules don't travel**. Each air molecule just oscillates back and forth a tiny amount around its equilibrium position. What propagates is the *pattern* — the pressure disturbance. This is the same distinction as a wave on water: the water molecules move up and down, but the wave shape moves laterally.

## Longitudinal vs. Transverse

You know EM waves are transverse — the electric and magnetic fields oscillate perpendicular to the direction of propagation. Sound is the opposite: **longitudinal**. The molecule displacement is parallel to the propagation direction.

Imagine pushing and pulling a slinky along its length versus shaking it side to side. Sound is the push-pull version. This matters because:

- Longitudinal waves require a medium that can be compressed (has bulk stiffness)
- Transverse waves require a medium that resists shear

Air and liquids have bulk stiffness but no shear stiffness, so they only support longitudinal waves. Solids have both, which is why structural acoustics gets more complicated — solids carry both compressional *and* shear waves, which travel at different speeds.

## Why Sound Needs a Medium

EM waves are self-sustaining — a changing E field generates a B field, which generates an E field, propagating through pure vacuum. Sound has no such mechanism. The propagation is purely mechanical: molecule A pushes molecule B. No molecules, no propagation. Hence: no sound in space, no sound in a hard vacuum.

This also means the wave properties (especially speed) are entirely determined by the medium, not by the source.

## Wavefronts: Point Sources vs. Plane Waves

A point source radiates spherically — the wavefront at any instant is a sphere expanding outward. As it expands, the same energy is spread over an ever-larger surface area, which is why intensity drops with distance (more on this in Lesson 4).

Far away from a source, any small patch of that spherical wavefront looks locally flat — it's approximately a **plane wave**, where the pressure is uniform across any plane perpendicular to propagation. Plane waves are the simplest case to analyze and what you get from a large, distant source. In practice, inside a room nothing is truly a plane wave, but it's a useful idealization.

## How the Medium Matters

Speed and behavior depend entirely on what the sound is traveling through:

| Medium | Speed |
|--------|-------|
| Air (20°C) | ~343 m/s |
| Water | ~1480 m/s |
| Steel | ~5100 m/s |

The general rule: stiffer and less dense = faster. This becomes important when sound hits a boundary between two media — covered in Lesson 7.

---

## Exercise

**A 100 Hz tone and a 5000 Hz tone are both playing in a room. The door is open a crack — about 10 cm wide. Which frequency do you hear more clearly from the hallway, and why?**

*(Reason from first principles — no calculation needed.)*

---

*Next: [Lesson 2 — The Parameters of a Wave](lesson_02_wave_parameters.md)*
