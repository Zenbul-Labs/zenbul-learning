# 01 — Wave Fundamentals

## What a Sound Wave Actually Is

Sound is a mechanical pressure wave — a propagating disturbance in the local density and pressure of a medium. Unlike EM waves, it requires a medium: it's molecules pushing on molecules.

Compress a small volume of air and release it. That compression doesn't stay put — it propagates outward because the compressed region pushes on adjacent air, which then compresses and pushes on the next layer, and so on. The molecules themselves don't travel far; they oscillate back and forth around equilibrium. What travels is the pattern of compression and rarefaction.

This makes sound a **longitudinal** wave: particle displacement is parallel to the direction of propagation, unlike transverse waves (EM, string waves) where displacement is perpendicular.

## The Wave Equation

Start from first principles: Newton's second law on a fluid element, plus the continuity equation (conservation of mass), plus a constitutive relation (adiabatic compression for air). Combining them gives the acoustic wave equation:

$$\nabla^2 p = \frac{1}{c^2} \frac{\partial^2 p}{\partial t^2}$$

where $p$ is the acoustic pressure (deviation from ambient) and $c$ is the speed of sound. This is the same PDE form you've seen for EM fields, vibrating strings, and quantum wavefunctions — the wave equation is universal.

In 1D (plane wave propagation along x):

$$\frac{\partial^2 p}{\partial x^2} = \frac{1}{c^2} \frac{\partial^2 p}{\partial t^2}$$

General solution: $p(x, t) = f(x - ct) + g(x + ct)$ — any right-traveling plus any left-traveling waveform. For a single sinusoidal plane wave:

$$p(x, t) = P_0 \cos(kx - \omega t + \phi)$$

where $k = \omega/c$ is the wavenumber and $\omega = 2\pi f$ is angular frequency. You already know this form from EM.

## Speed of Sound

For an ideal gas, the wave equation derivation gives:

$$c = \sqrt{\frac{\gamma P_0}{\rho_0}} = \sqrt{\frac{\gamma R T}{M}}$$

where $\gamma$ is the adiabatic index (1.4 for diatomic air), $R$ is the gas constant, $T$ is absolute temperature, and $M$ is molar mass.

Key consequence: **speed depends on temperature, not pressure** (at constant temperature, increasing pressure also increases density proportionally, and the two effects cancel). At 20°C, $c \approx 343$ m/s in air.

The adiabatic assumption (rather than isothermal) is important: compression happens fast enough that there's no time for heat exchange with surroundings, so $PV^\gamma = \text{const}$ rather than $PV = \text{const}$. Newton originally derived $c = \sqrt{P_0/\rho_0}$ using the isothermal assumption and got an answer ~18% too low. Laplace fixed it by adding $\gamma$.

## Particle Velocity and Acoustic Pressure

The wave equation describes pressure, but the medium also has a velocity field. For a plane wave, pressure $p$ and particle velocity $u$ are related by:

$$p = \rho_0 c \, u$$

The quantity $\rho_0 c$ is the **characteristic acoustic impedance** of the medium (units: Pa·s/m = Rayl). For air at 20°C, $Z_0 = \rho_0 c \approx 415$ Rayl. For water, $Z_0 \approx 1.5 \times 10^6$ Rayl — about 3600× higher.

This is exactly analogous to the wave impedance of a transmission line ($Z_0 = \sqrt{L/C}$) or free space ($\eta_0 = \sqrt{\mu_0/\epsilon_0} \approx 377\ \Omega$). The impedance ratio between two media governs how much of a wave reflects vs. transmits at an interface — more on that in document 05.

## Energy and Intensity

Acoustic intensity (power per unit area, W/m²) for a plane wave:

$$I = \frac{p^2}{\rho_0 c} = \frac{P_0^2}{2 \rho_0 c}$$

where $P_0$ is the pressure amplitude (the factor of 2 in the denominator comes from time-averaging $\cos^2$).

Intensity falls off as $1/r^2$ for a point source in free field (spherical spreading) — same as EM radiation in the far field.

## Decibels

Sound pressure level (SPL) in decibels:

$$L_p = 20 \log_{10}\left(\frac{p_\text{rms}}{p_\text{ref}}\right) \text{ dB}$$

Reference pressure $p_\text{ref} = 20\ \mu\text{Pa}$ — chosen as the approximate threshold of human hearing at 1 kHz. Since intensity scales as $p^2$, this is equivalent to $10 \log_{10}(I/I_\text{ref})$, consistent with the power-decibel definition you know from RF.

Some anchor points:
- 0 dB SPL: threshold of hearing
- 60 dB SPL: normal conversation (~1 m)
- 94 dB SPL: 1 Pa rms (calibration reference for microphones)
- 120 dB SPL: threshold of pain
- 194 dB SPL: theoretical limit in air at 1 atm (pressure amplitude = ambient pressure — wave goes nonlinear before this)

## What's Non-Obvious

**Linearity has limits.** The wave equation above is linear, derived assuming small perturbations ($p \ll P_0$). At high amplitudes the wave steepens as the compressed (faster) regions catch up to the rarefied (slower) regions, eventually forming a shock. This matters for transducers driven hard and for ultrasonic applications.

**Sound in solids is richer.** Solids support both longitudinal (compressional) and transverse (shear) waves, because solids have shear stiffness. Liquids support only longitudinal. This is why structural acoustics and ultrasonics in materials are significantly more complex.

**Near field vs. far field.** Close to a source, the pressure and velocity fields are not in phase (reactive near field). The simple $p = \rho_0 c \, u$ relation only holds in the far field / plane wave limit. This matters a lot for microphone placement and transducer design.

---

*Next: [Frequency, Amplitude, and Phase](02_frequency_amplitude_phase.md) — the parameters of a wave and their physical meaning, including why phase matters more than it might seem.*
