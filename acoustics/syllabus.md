# Acoustics 101 — Syllabus

**Goal:** Build a solid conceptual model of how sound works — enough to reason about acoustic problems, ask the right questions, and direct technical work without needing to derive anything yourself.

**Format:** Interactive lessons in Claude Code. Each lesson presents concepts, checks understanding with light exercises, and leaves room for questions. No heavy math — equations show up when they add clarity, not as the point.

**Assumed background:** EE/robotics level. Signal processing intuition, comfort with frequency domain thinking, familiarity with wave phenomena from EM.

---

## Lesson 1 — What Is Sound?
*The physical picture from scratch.*

- What a pressure wave actually is — compression and rarefaction, not traveling molecules
- Longitudinal vs. transverse waves and why sound is longitudinal
- How sound travels through different media (air, water, solids)
- Wavefronts, point sources, plane waves
- Why sound needs a medium (and what that implies for vacuum, space, etc.)

**Exercise:** Predict qualitatively — does sound travel faster in water or air, and why?

---

## Lesson 2 — The Parameters of a Wave
*Frequency, amplitude, wavelength, phase — what each one is and what it means.*

- Frequency and period — cycles per second as the fundamental descriptor
- Wavelength and its relationship to frequency and speed
- Amplitude — what it represents physically (pressure swing) and perceptually (loudness)
- Phase — the most underrated parameter; why it matters even when you can't hear it directly
- The audible frequency range and what lives outside it

**Exercise:** If a 1 kHz tone and a 100 Hz tone are both playing in a room, which one bends around a doorframe more easily, and why?

---

## Lesson 3 — The Frequency Domain
*Why spectrum is the natural frame for thinking about audio.*

- Time domain vs. frequency domain — two views of the same signal
- What a spectrum tells you that a waveform doesn't
- Harmonics, overtones, and why real instruments don't produce pure tones
- Timbre as spectral shape
- Noise: white, pink, brown — what the colors mean physically

**Exercise:** A note on a piano and the same note on a violin play at the same pitch and loudness. What's different between them, physically?

---

## Lesson 4 — How Sound Behaves in Space
*Propagation, distance, directionality, and obstacles.*

- Inverse square law — why loudness drops with distance, and how fast
- Reflection: what bounces and what doesn't
- Absorption: materials as frequency-dependent sponges
- Diffraction: sound bending around obstacles, and why wavelength relative to object size is the key ratio
- Directionality of sources — why a tweeter beams and a woofer doesn't

**Exercise:** You're designing a sound system for a long hallway. A PA speaker is at one end. What frequency range will reach the far end most effectively, and why?

---

## Lesson 5 — Interference and Superposition
*What happens when waves overlap.*

- Superposition — waves add, not collide
- Constructive and destructive interference
- Comb filtering: what it sounds like and when it appears
- Standing waves — interference between a wave and its own reflection
- Room modes: why certain frequencies are louder in certain spots

**Exercise:** You move a microphone 1 meter further from a speaker. A 340 Hz tone drops to near-silence. What's happening?

---

## Lesson 6 — Decibels and Loudness
*The logarithmic scale and why it exists.*

- Why decibels — the ear is logarithmic, and dynamic range is enormous
- SPL: the physical measurement (Pa) vs. the dB scale
- dBFS, dBu, dBV — the alphabet soup of audio levels and when each is used
- Equal loudness curves: the same SPL sounds different at different frequencies
- Loudness vs. level: perceived loudness is not the same as measured amplitude

**Exercise:** A sound increases by 10 dB. Roughly how much louder does it sound? How much more acoustic power is that?

---

## Lesson 7 — Acoustic Impedance and Boundaries
*What happens when sound hits an interface between media.*

- Acoustic impedance as a material property — the acoustic analog of electrical impedance
- Reflection and transmission at boundaries — impedance mismatch as the key concept
- Why sound barely enters water from air (and vice versa)
- Practical implications: speaker enclosures, room boundaries, microphone capsule design
- Absorption coefficient — a material's frequency-dependent "how much it reflects"

**Exercise:** Why is it so hard to hear someone talking underwater from above the surface, even if they're screaming?

---

## Lesson 8 — Transducers: Microphones and Speakers
*Converting between acoustic and electrical domains.*

- The transducer job: map pressure variations to voltage (mic) or voltage to pressure (speaker)
- Microphone types: dynamic, condenser, ribbon — the physical mechanism of each
- Polar patterns: omnidirectional, cardioid, figure-8 — what they mean and why they exist
- Speaker drivers: woofers, tweeters, midrange — why one driver can't do it all
- Frequency response: what a flat response means and why it's hard to achieve

**Exercise:** You need to record a loud drummer without clipping. Dynamic or condenser mic — which is safer and why?

---

## Lesson 9 — Psychoacoustics
*How the brain processes sound — where physics and perception diverge.*

- The auditory system as a signal processor: ear canal, cochlea, auditory nerve
- Pitch perception: frequency is physical, pitch is perceptual — and they're not always the same
- Masking: loud sounds hiding quieter ones, in frequency and in time
- Spatial hearing: how we localize sound (ITD, ILD, and HRTFs)
- The cocktail party effect and auditory scene analysis

**Exercise:** A recording has a loud kick drum and a bass guitar occupying similar frequency ranges. Why do they fight each other in the mix, and what's the acoustic reason EQ can help?

---

## Lesson 10 — Rooms, Reverb, and Digital Audio
*Acoustics in real environments and the digital chain.*

- Room acoustics: early reflections, late reverberation, RT60
- Impulse responses: a room as a filter — everything a room does to a sound, captured in one measurement
- Acoustic treatment: absorption vs. diffusion and what each one fixes
- Digital audio fundamentals: sampling rate, bit depth, aliasing — enough to reason about the pipeline
- What DSP can fix and what requires physical acoustic treatment

**Exercise:** A recording sounds "boxy" — there's a resonant coloration that doesn't go away no matter how you EQ it. What's likely causing it physically, and is it fixable in post?

---

## Appendix: Key Mental Models to Keep

By the end of this course you should have these intuitions loaded:

1. **Sound = pressure variations propagating through a medium** — always come back to the physical picture
2. **Frequency domain is the natural frame** — most acoustic phenomena make more sense in spectrum than in waveform
3. **Wavelength relative to object size governs everything** — diffraction, directionality, room modes
4. **Impedance mismatch = reflection** — at every boundary, energy either transmits or bounces back
5. **The ear is logarithmic** — dB is not a quirk, it's matched to perception
6. **Physics ≠ perception** — psychoacoustics consistently surprises, don't trust naive intuitions about what you'll hear
