# MRI Z-Gradient-Coil Design via Particle Swarm Optimisation (EE303 Project)

This repository contains the MATLAB (R2023) implementation for the special assignment of the **EE303: Numerical Analysis** course (Fall 2023, University of Tripoli). The project uses **Particle Swarm Optimisation (PSO)** to design a longitudinal gradient coil for an MRI system. [cite_start]The goal is to strategically place multiple coaxial loop pairs to ensure the axial magnetic field component, $B_z(z)$, is as linear as possible within a ±0.25 m region of interest.

<p align="center">
  <img src="./results/optimized_vs_desired_field.png" width="600" alt="Optimised vs. desired field profile">
</p>

---

## 1 · Theoretical Background

### Longitudinal Gradient Coils

[cite_start]In MRI, gradient fields are superimposed on the main static magnetic field to spatially encode the signal, which is essential for forming an image. [cite_start]The longitudinal (z-axis) gradient is often generated using a **Maxwell coil**, which consists of two identical circular loops. [cite_start]By adding more loop pairs at symmetric positions $\pm z_n$, the linearity of the magnetic field can be significantly improved.

[cite_start]The total axial magnetic field $B_z$ for $N$ pairs of loops is given by:

$$B_z(z)= \frac{\mu_0 I a^{2}}{2}\sum_{n=1}^{N} \left( \frac{1}{((z-z_{n})^{2}+a^{2})^{3/2}} - \frac{1}{((z+z_{n})^{2}+a^{2})^{3/2}} \right)$$

[cite_start]The core of this project is to find the optimal positions $\mathbf{Z} = [z_1, z_2, ..., z_N]$ that minimize the integrated squared error between the generated field $B_z(z; \mathbf{Z})$ and a desired linear target field, $B_z^{desired}(z) = kz$. [cite_start]The error function $E$ is defined as:

$$E=\int_{-L}^{L} \! \left[B_z(z; \mathbf{Z})-B_z^{desired}(z)\right]^{2}\,dz$$

### Why Particle Swarm Optimisation?

The error function $E(\mathbf{Z})$ is complex and non-convex. Traditional gradient-based optimization methods are not suitable because they can get stuck in local minima and require derivatives that are complex to compute. [cite_start]**Particle Swarm Optimisation (PSO)** is an ideal choice for this problem because:
* [cite_start]It is a derivative-free algorithm, relying only on evaluating the fitness function.
* [cite_start]It performs a parallel search of the solution space, making it robust against local minima.
* [cite_start]Particles in the swarm share information to collaboratively guide the search toward the best solution.

---

## 2 · Algorithm and Implementation

The PSO algorithm was implemented in MATLAB to search for the optimal coil positions. The key parameters were chosen based on the assignment brief and common PSO practices.

| Parameter | Value | Rationale |
| :--- | :--- | :--- |
| **Swarm Size** | 25 particles | [cite_start]Meets the assignment requirement of using more than 8 agents. |
| **Iterations** | 500 | An empirical value found to be sufficient for the algorithm to converge. |
| **Cognitive Constant ($c_1$)** | 2 | A standard, canonical value for the PSO acceleration constant. |
| **Social Constant ($c_2$)** | 2 | A standard, canonical value for the PSO acceleration constant. |
| **Inertia Weight ($w$)**| 0.9 → 0.4 (linear decay) | Balances global exploration at the start with local exploitation later on. |
| **Max Velocity ($V_{max}$)** | 0.5 m/iteration | Limits the step size to prevent particles from leaving the search space. |
| **Search Space ($z_n$)**| [0, 0.5] m | [cite_start]A suitable boundary for the coil positions. |

The fitness function $E$ was evaluated using **Simpson's 3/8 rule** for numerical integration, which provides a good balance between accuracy and computational speed. The integration was performed over 300 segments.

---

## 3 · Repository Structure

| Path | Contents |
| :--- | :--- |
| **`src/`** | Contains all MATLAB source files (`special.m`, `Bz.m`, `integral.m`, `test.m`). |
| **`docs/`** | Contains the original assignment brief (`Special_assignment.pdf`). |
| **`results/`** | Contains the output plot (`optimized_vs_desired_field.png`). |
| **`.gitignore`** | Standard Git ignore file for MATLAB projects. |
| **`LICENSE`** | The MIT License for this project. |
| **`README.md`** | You are here. |

---

## 4 · How to Reproduce Results

#### Prerequisites
* MATLAB R2023 or a compatible version.

#### Steps
1.  Clone the repository to your local machine:
    ```bash
    git clone [https://github.com/YourUsername/MRI-Gradient-Coil-Design-PSO.git](https://github.com/YourUsername/MRI-Gradient-Coil-Design-PSO.git)
    cd MRI-Gradient-Coil-Design-PSO
    ```
2.  Open MATLAB.
3.  Navigate to the `src` directory and run the main script. To save the resulting plot, use the `saveas` command.
    ```matlab
    % In MATLAB Command Window
    cd src
    special  % Runs the PSO algorithm and generates the plot
    saveas(gcf, '../results/optimized_vs_desired_field.png');
    ```

#### Expected Output
The script will print the final optimized positions and the minimum error value to the command window. The format will be:
```
gbest =
    [0.000, 0.112, 0.183, 0.249, ...]  % A 1x8 vector of optimized positions (m)

gbest_value =
    1.03e-08                          % The final integrated squared error (T²·m)
```

---

## 5 · Code Description

* **`special.m`**: The main driver script. [cite_start]It initializes the PSO parameters, manages the optimization loop, and plots the final results.
* [cite_start]**`Bz.m`**: A function that calculates the magnetic field $B_z$ at a point `z` based on Equation (3) from the assignment brief.
* [cite_start]**`integral.m`**: Implements Simpson's 3/8 rule for numerical integration, used to calculate the fitness/error value.
* **`test.m`**: A supplementary script used for brute-force grid search during development for sanity-checking the problem space.

---

## 6 · References

* **Assignment Brief:** [docs/Special_assignment.pdf](docs/Special_assignment.pdf)
* **PSO Background:** [Implementing Particle Swarm optimization from Scratch](https://python.plainenglish.io/implementing-particle-swarm-optimization-from-scratch-34608b475afd) by Muhammad Saad Uddin.

---

## 7 · License

This project is released under the **MIT License**. See the `LICENSE` file for full details.
