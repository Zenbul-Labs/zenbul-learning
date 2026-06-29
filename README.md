# Zenbul Learning

A technical education system for Zenbul employees — built around the idea that a 24/7 AI teacher changes the economics of learning fundamentally.

Traditional courses are scheduled, paced for the median student, and frozen at the moment they were recorded. This is different: you ask, you get an explanation calibrated to exactly what you already know, right now. You can go deeper, go sideways, challenge the explanation, or skip what's obvious. The feedback loop is immediate.

## Philosophy

The baseline assumption here is an engineer with a strong quantitative background — math through differential equations, some signal processing intuition, programming fluency. Explanations don't pad out with definitions you already have. They go straight to the physics, the engineering tradeoffs, and the non-obvious parts.

If something is unclear, ask. That's the point.

## Topics

### Acoustics
*Starting point for the learning system.*

Acoustics sits at the intersection of mechanical wave physics, signal processing, and perception — a domain where the math is tractable and the engineering implications are immediate. For anyone building audio hardware or software, it's foundational.

The sequence runs from wave physics through to applied audio engineering:

| # | Topic | What you'll understand |
|---|-------|----------------------|
| 01 | [Wave Fundamentals](acoustics/01_wave_fundamentals.md) | Pressure waves, the wave equation, speed of sound |
| 02 | [Frequency, Amplitude, Phase](acoustics/02_frequency_amplitude_phase.md) | The parameters of a wave and what each one means physically |
| 03 | [Superposition and Interference](acoustics/03_superposition_interference.md) | Why waves add linearly, constructive/destructive interference |
| 04 | [Fourier Analysis](acoustics/04_fourier_analysis.md) | Any periodic signal as a sum of sinusoids — and why this is the right frame |
| 05 | [Reflection, Transmission, Absorption](acoustics/05_reflection_transmission_absorption.md) | What happens at boundaries between media |
| 06 | [Resonance and Standing Waves](acoustics/06_resonance_standing_waves.md) | Modes, resonant frequencies, room acoustics |
| 07 | [Impedance](acoustics/07_impedance.md) | Acoustic impedance, matching, and why it matters for transducers |
| 08 | [Transducers](acoustics/08_transducers.md) | Microphones and speakers as electromechanical systems |
| 09 | [Psychoacoustics](acoustics/09_psychoacoustics.md) | How perception filters the physics — loudness, pitch, masking |
| 10 | [Room Acoustics and DSP](acoustics/10_room_acoustics_dsp.md) | Reverberation, impulse responses, and what you can do in software |

*More topics (RF, embedded systems, DSP, signal integrity) to be added.*

## How to Use This

Each document is a starting point, not a complete lecture. Read it, then open a conversation with Claude and go wherever the material takes you. The document gives you the frame; the conversation is where the actual learning happens.

Suggested approach:
1. Read through the document for the topic
2. Start a Claude conversation with the document as context
3. Ask about anything that's hand-wavy, missing, or that you want to go deeper on
4. Ask for worked examples, derivations, or connections to things you already know

## Contributing

Add topics, extend existing ones, or flag where an explanation is wrong or incomplete. This is a living document.
