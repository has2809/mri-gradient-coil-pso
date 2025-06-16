# MRI Z-Gradient-Coil Design via Particle Swarm Optimisation (EE303 Project)

This repository contains my MATLAB (R2023) implementation of **Particle Swarm Optimisation (PSO)** to place
multiple coaxial loop pairs so that the axial magnetic-field component  
\(B_z(z)\) inside a ±0.25 m region is as linear as possible.  
The work was submitted as the *special assignment* for **EE303 · Numerical Analysis** (Fall 2023, University of Tripoli).

<p align="center">
  <img src="results/field_profile.png" width="560"
       alt="Optimised vs. desired field profile">
</p>

---

## 1 · Physical background

MRI scanners superimpose weak, linearly varying *gradient fields* on top of the strong
static B-field. A classic way to generate the **longitudinal ( z-axis ) gradient**
is the *Maxwell coil*: two identical circular loops separated by a distance \(a/\sqrt{3}\).
Adding more **loop pairs at positions \(\pm Z_n\)** allows us to fine-tune linearity:  

\[
B_z(z)= \frac{\mu_0 I a^{2}}{2}\sum_{n=1}^{N_\text{pairs}}
\left[(z-Z_n)^2+a^{2}\right]^{-3/2}\;-\;
\left[(z+Z_n)^2+a^{2}\right]^{-3/2}
\]

The assignment fixed the current \(I\) and loop radius \(a\) and asked us to
choose the \(Z_n\) that minimise the squared error

\[
E=\int_{-L}^{L}
\!\left[B_z(z; \mathbf Z)-kz\right]^{2}\,dz
\tag{★}
\]

where \(k=10^{-3}\,\text{T m}^{-1}\).  
Full specifications are reproduced in *docs/Special_assignment.pdf* :contentReference[oaicite:0]{index=0}.

**Why PSO?**  
\(E(\mathbf Z)\) is non-convex and derivative-free; PSO excels at such searches
because particles exchange the best information they have found, explore in parallel, and
require only function evaluations – no gradients :contentReference[oaicite:1]{index=1}.

---

## 2 · Repository structure

| Path | Contents |
|------|----------|
| **src/** | Unmodified MATLAB source (`special.m`, `integral.m`, `Bz.m`, `test.m`) |
| **docs/** | Assignment brief (PDF) |
| **results/** | `field_profile.png` (generated plot) |
| `.gitignore` | Ignores MATLAB autosaves, OS cruft |
| `LICENSE` | MIT |
| `README.md` | *you are here* |

---

## 3 · Algorithm highlights

| Parameter | Value | Rationale |
|-----------|-------|-----------|
| Particles | 25 | ≥ 8 as requested by brief |
| Iterations | 500 | Empirically convergent |
| \(c_1,c_2\) | 2, 2 | Canonical PSO acceleration constants |
| Inertia \(w\) | 0.9→0.4 (linear decay) | Balances exploration ↔ exploitation |
| Velocity cap | ±0.5 m | Matches search-space width |

Fitness \(E\) is evaluated with **Simpson’s 3/8 rule** (`integral.m`, 300 segments) for
accuracy without sacrificing speed.

---

## 4 · Reproducing the results

```matlab
% MATLAB R2023
cd src
special                      % runs PSO, prints gbest & plots field
saveas(gcf,'../results/field_profile.png');
````

Expected output:

```
gbest = [ 0.000, 0.112, 0.183, 0.249, … ]   % eight positions (m)
gbest_value = 1.03e-08                      % integrated error (T²·m)
```

The saved PNG is the figure embedded at the top of this README.

---

## 5 · Key files

* **special.m** – PSO driver implementing the loop of (position → velocity → evaluation → update).
* **Bz.m** – Magnetic-field model for an N-pair Maxwell-like coil.
* **integral.m** – Simpson 3/8 integrator used in Eq. (★).
* **test.m** – Brute-force grid search (6 pairs) for sanity checks.

---

## 6 · Further reading

* Assignment specification (PDF) – *docs/Special\_assignment.pdf*&#x20;
* Muhammad Saad Uddin, “Implementing PSO from Scratch,” *Python in Plain English*, 2022. (Link in code comments)&#x20;

---

## 7 · Licence

Released under the **MIT Licence**. See `LICENSE` for details.
