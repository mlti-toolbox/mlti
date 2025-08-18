---
layout: page
title: ForwardModel
hyperlink: /ForwardModel
---

# ForwardModel

Models the surface thermal response due to a harmonic laser heat source

## Description

## Creation

### Syntax

```matlab
fm = ForwardModel(Name, Value)
```

### Description

`fm = ForwardModel(Name, Value)` creates a forward model object according to specifications provided as name-value arguments.

### Input (Name-Value) Arguments

Specify name–value pairs as `Name1=Value1, ..., NameN=ValueN`, where each `Name` is an argument name and each `Value` is the corresponding value. The order of the pairs does not matter.  

Argument names are validated using [`validatestring`](https://www.mathworks.com/help/matlab/ref/validatestring.html), making them **case-insensitive**. You can also use any unique leading substring of the name. For example, the name `'ift'` matches the option `'ift_method'`.

*Before R2021a, separate each name and value with commas and enclose* `Name` *in quotes.*  

**Example:**  
```matlab
fm = ForwardModel(ift_method="ifft2", x_max=25, dx=0.5, scale=1e-6, ...)
% Equivalent pre-R2021a syntax:
fm = ForwardModel('ift_method', "ifft2", 'x_max', 25, 'dx', 0.5, 'scale', 1e-6, ...)
```

#### Options

<details>
  <summary><b>
    <code>ift_method</code> - 2-D inverse Fourier transform method
  </b></summary>

  <br>

  2-D inverse Fourier transform method.
  When possible, the [`ifft2`](https://www.mathworks.com/help/matlab/ref/ifft2.html) method should be used for its computational efficiency.
  However, if greater accuracy is needed, the [`integral2`](https://www.mathworks.com/help/matlab/ref/integral2.html) method may be used instead.

  When `ift_method = "ifft2"`, either `x_max` or `dx` must be provided. `Nx` has a default value, but `x_max` and `dx` do not. At least two of the three (`x_max`, `Nx`, `dx`) must be known to compute the third.
  
  **Value Options:** `'ifft2'` (default) | `'integral2'`
  
  Vaue options are validated using [`validatestring`](https://www.mathworks.com/help/matlab/ref/validatestring.html).
    
  **Data Types:** `string` | `char`
  
  <br>
  
</details>

<details>
  <summary><b>
    <code>x_max</code> - maximum spatial distance from pump
  </b></summary>

  <br>

  Maximum spatial distance from the pump in the x- and y-directions used in the 2-D inverse fast Fourier transform ([`ifft2`](https://www.mathworks.com/help/matlab/ref/ifft2.html)).
  I.e., the spatial domain for both `x_probe` and `y_probe` will be `[-x_max, x_max]`.

  The value of `x_max` is ignored when `ift_method = "integral2"`.

  **Value Options:** positive scalar value
    
  **Data Types:** `double`
  
  <br>
  
</details>

<details>
  <summary><b>
    <code>Nx</code> - number of spatial steps
  </b></summary>

  <br>

  Number of descrete spatial points to use in the `ifft2` transform.
  I.e., signal length.
  
  When possible, the value of `Nx` should only have small prime factors as this results in significantly faster execution of the `ifft2` transform.

  The value of `Nx` is ignored when `ift_method = "integral2"`.
  Furthermore, If all three `x_max`, `Nx`, and `dx` are provided as inputs, `Nx` will be ignored.


  **Value Options:** 256 (default) | positive scalar value
    
  **Data Types:** `double`

  <br>
  
</details>

<details>
  <summary><b>
    <code>dx</code> - step size
  </b></summary>

  <br>

  Descrete spatial step size.
  
  The value of `dx` is ignored when `ift_method = "integral2"`.

  **Value Options:** positive scalar value
    
  **Data Types:** `double`

  <br>
  
</details>

<details>
  <summary><b>
    <code>scale</code> - input scale factor
  </b></summary>

  <br>

  The input scale factor defines the units of certain forward model inputs by scaling their base SI units as follows:
  * $$\left[ h_f \right] = \left[ h_s \right] = \left[ s_x \right] = \left[ s_y \right] = \left[ x_\mathrm{probe} \right] = \mathrm{scale} \cdot \mathrm{m}$$
  * $$\left[ \alpha_f \right] = \left[ \alpha_s \right] = \left[ u \right] = \left[ v \right] = \left[\frac{1}{ x_\mathrm{probe}} \right] = \frac{1}{\mathrm{scale} \cdot \mathrm{m}}$$
  * $$\left[C_f\right] = \left[C_s\right] = \frac{\mathrm{W}}{\mathrm{scale} \cdot \mathrm{m}^3 \cdot \mathrm{K}}$$
  * $$\left[ P \right] = \left[ \mathrm{scale} \cdot \mathrm{W} \right]$$
  * $$\left[ f_0 \right] = \left[\frac{\mathrm{Hz}}{\mathrm{scale}} \right]$$

  **Example:** If ```scale = 1e-6``` forward model inputs are considered to be in the following units:
  * $$\left[ h_f \right] = \left[ h_s \right] = \left[ s_x \right] = \left[ s_y \right] = \left[ x_\mathrm{probe} \right] = \mathrm{scale} \cdot \mathrm{m} = 10^{-6} \cdot \mathrm{m} = \mathrm{\upmu m}$$
  * $$\left[ \alpha_f \right] = \left[ \alpha_s \right] = \left[ u \right] = \left[ v \right] = \left[\frac{1}{ x_\mathrm{probe}} \right] = \frac{1}{\mathrm{scale} \cdot \mathrm{m}} = \frac{1}{10^{-6} \cdot \mathrm{m}} = \frac{1}{\mathrm{\upmu m}}$$
  * $$\left[C_f\right] = \left[C_s\right] = \frac{\mathrm{W}}{\mathrm{scale} \cdot \mathrm{m}^3 \cdot \mathrm{K}} = \frac{\mathrm{W}}{10^{-6} \cdot \mathrm{m}^3 \cdot \mathrm{K}} = \frac{\mathrm{W}}{\mathrm{cm}^3 \cdot \mathrm{K}}$$
  * $$\left[ P \right] = \left[ \mathrm{scale} \cdot \mathrm{W} \right] = \left[ 10^{-6} \cdot \mathrm{W} \right] = \left[ \mathrm{\upmu W} \right]$$
  * $$\left[ f_0 \right] = \left[\frac{\mathrm{Hz}}{\mathrm{scale}} \right] = \left[\frac{\mathrm{Hz}}{10^{-6}} \right] = \left[ 10^6 \cdot \mathrm{Hz} \right] = \left[ \mathrm{MHz} \right]$$

  **Value Options:** 1 (default) | positive scalar value
    
  **Data Types:** `double`

  <br>
  
</details>

<details>
  <summary><b>
    <code>film_isotropy</code> - film isotropy type
  </b></summary>

  <br>

  Film isotropy type specifies the isotropy level of the film.
  
  **Value Options:**
  * `'iso'`: For scalar thermal conductivity `kf`
  * `'simple'`: For 2 principal thermal conductivities along a specified axis `kf∥` and perpendicular to that axis `kf⊥` 
  * `'complex'`: For 3 principal thermal conductivities sorted in descending order `kfp1`, `kfp2`, `kfp3` 
  * `'tensor'` (default): For 6 element thermal conductivity tensor `kf11`, `kf12`, `kf13`, `kf22`, `kf23`, `kf33`
    
  **Data Types:** `string` | `char`

  <br>
  
</details>

<details>
  <summary><b>
    <code>sub_isotropy</code> - substrate isotropy type
  </b></summary>

  <br>

  Substrate isotropy type specifies the isotropy level of the substrate.
  
  **Value Options:**
  * `'iso'`: For scalar thermal conductivity `ks`
  * `'simple'`: For 2 principal thermal conductivities along a specified axis `ks∥` and perpendicular to that axis `ks⊥` 
  * `'complex'`: For 3 principal thermal conductivities sorted in descending order `ksp1`, `ksp2`, `ksp3` 
  * `'tensor'` (default): For 6 element thermal conductivity tensor `ks11`, `ks12`, `ks13`, `ks22`, `ks23`, `ks33`
    
  **Data Types:** `string` | `char`

  <br>
  
</details>

<details>
  <summary><b>
    <code>film_orient</code> - film orientation type
  </b></summary>

  <br>

  Film orientation type specifies how the principal axes orientations of the film are represented.
  Required when `film_isotropy` equals either `'simple'` or `'complex'`.
  
  **Value Options:**
  * `'azpol'`: For representing the `kf∥` axis as azimuthal `θf1` and polar `θf2` angles. Use only when `film_isotropy = 'simple'`.
  * `'uvect'`: For representing the `kf∥` axis as a unit vector `vf1`, `vf2`, `vf3`. Use only when `film_isotropy = 'simple'`.
  * `'euler'`: For representing the orientation of the principal axes as Euler angles `θf1`, `θf2`, `θf3`.
  * `'uquat'`: For representing the orientation of the principal axes as a unit quaternion `qf1`, `qf2`, `qf3`, `qf4`.
  * `'rotmat'`: For representing the orientation of the principal axes as a rotation matrix `Rf11`,`Rf21`,`Rf31`,`Rf12`,`Rf22`,`Rf32`,`Rf13`,`Rf23`,`Rf33`.
    
  **Data Types:** `string` | `char`

  <br>
  
</details>

<details>
  <summary><b>
    <code>sub_orient</code> - substrate orientation type
  </b></summary>

  <br>

  Substrate orientation type specifies how the principal axes orientations of the substrate are represented.
  Required when `sub_isotropy` equals either `'simple'` or `'complex'`.
  
  **Value Options:**
  * `'azpol'`: For representing the `ks∥` axis as azimuthal `θs1` and polar `θs2` angles. Use only when `sub_isotropy = 'simple'`.
  * `'uvect'`: For representing the `ks∥` axis as a unit vector `vs1`, `vs2`, `vs3`. Use only when `sub_isotropy = 'simple'`.
  * `'euler'`: For representing the orientation of the principal axes as Euler angles `θs1`, `θs2`, `θs3`.
  * `'uquat'`: For representing the orientation of the principal axes as unit quaternions `qs1`, `qs2`, `qs3`, `qs4`.
  * `'rotmat'`: For representing the orientation of the principal axes as a rotation matrix `Rs11`,`Rs21`,`Rs31`,`Rs12`,`Rs22`,`Rs32`,`Rs13`,`Rs23`,`Rs33`.
    
  **Data Types:** `string` | `char`

  <br>
  
</details>

<details>
  <summary><b>
    <code>euler_seq</code> - Euler angle sequence
  </b></summary>

  <br>

  Euler angle sequence specified as three axes.  
  I.e., computes the rotation matrix as `R = Ri(θ1) * Rj(θ2) * Rk(θ3)`, where `i`, `j`, `k` are the 1st, 2nd, and 3rd characters of the input character array, and:
  ```
  Rx(θ) = [   1        0        0
              0      cos(θ)  -sin(θ)
              0      sin(θ)   cos(θ) ]

  Ry(θ) = [ cos(θ)     0      sin(θ)
              0        1        0
           -sin(θ)     0      cos(θ) ]

  Rz(θ) = [ cos(θ)  -sin(θ)     0
            sin(θ)   cos(θ)     0
              0        0        1    ]
  ```
  Only referenced when either `film_orient` or `sub_orient` is set to `'euler'`.
  
  **Value Options:** `'ZYZ'` (default) | `'ZXZ'` | `'ZYX'` | `'ZXY'` | `'YXY'` | `'YZY'` | `'YXZ'` | `'YZX'` | `'XYX'` | `'XZX'` | `'XYZ'` | `'XZY'` |
    
  **Data Types:** `char` | `string`

  <br>
  
</details>

<details>
  <summary><b>
    <code>sweep_method</code> - Method for iterating over parameter combinations
  </b></summary>

  <br>

  Specifies how the forward model iterates over all combinations of
input parameter sets `M_train`, `O`, `f0`, `x_probe` when computing the
4-D output array `G(i,j,k,l) = fm.solve(M_train(i,:), O(j,:), chi, f0(k,:), x_probe(l,:))`. This choice affects both memory usage
and performance.

  **Value Options:**
  * "broadcast" (default) – Uses singleton expansion to apply
  `fm.solve(...)` over multi-dimensional parameter arrays without
  explicitly forming full grids in memory. Saves memory, but may be
  slower in some cases.
  * "ndgrid" – Expands all parameter arrays to full $N_\mathrm{train} \times N_\mathrm{pump} \times N_f \times N_\mathrm{prope}$ grids
  using [`ndgrid`](https://www.mathworks.com/help/matlab/ref/ndgrid.html). Fast for vectorized operations but uses the most
  memory.
  * "loop" – Iterates explicitly over all parameter combinations in
  nested `for` loops. Uses minimal memory but is typically the slowest
  method.
    
  **Data Types:** `string` | `char`

  <br>
  
</details>

<details>
  <summary><b>
    <code>inf_sub_thick</code> - use infinite substrate thickness approximation
  </b></summary>

  <br>

  When set to `true`, approximates the thickness of the substrate as infinite in the z-direction, which is more numerically stable than using a finite substrate thickness.
  
  **Value Options:** 1 (default) | 0
    
  **Data Types:** `logical`

  <br>
  
</details>

<details>
  <summary><b>
    <code>phase_only</code> - return phase only
  </b></summary>

  <br>

  When set to `true`, tells the solver that the user is only interested in phase; not amplitude nor DC temperature change.
  
  **Value Options:** 0 (default) | 1
    
  **Data Types:** `logical`

  <br>
  
</details>

<details>
  <summary><b>
    <code>force_sym_solve</code> - force reexecution of symbolic solution
  </b></summary>

  <br>

  When set to `true`, forces the reexecution of the symbolic solutions even if the files already exist.

  **Value Options:** 0 (default) | 1
    
  **Data Types:** `logical`

  <br>
  
</details>

<details>
  <summary><b>
    <code>log_args</code> - log arguments
  </b></summary>

  <br>

  When set to `true`, the solver expects the natural log of thermal conductivity, volumetric heat capacity, optical absorption coefficient, z-direction thickness, pump laser deviation, and power as inputs.

  **Value Options:** 0 (default) | 1
    
  **Data Types:** `logical`

  <br>
  
</details>

## Properties

<details>
  <summary><b>
    <code>c_args</code> - constructor arguments
  </b></summary>

  <br>

  Struct of input arguments passed into the constructor.
    
  **Data Types:** `struct`

  <br>
  
</details>

<details>
  <summary><b>
    <code>in_structure</code> - input structure
  </b></summary>

  <br>

  Specifies the expected input structure for `M`, `Theta`, and `chi` (inputs to `ForwardModel` functions).

  **Data Type:** 1-by-3 cell array, where each element is a string array

  **Example:** 

  <br>
  
</details>

<details>
  <summary><b>
    <code>in_sizes</code> - input sizes
  </b></summary>

  <br>

  Specifies the expected input sizes for `M`, `Theta`, and `chi` (inputs to `ForwardModel` functions).

  **Data Type:** 1-by-3 array of positive scalar values

  **Example:** 

  <br>
  
</details>

## Object Functions
| Function Name | Summary |
|---------------|---------|
| `solve`       | Solves the forward model |
| `plot`        | Plots the surface thermal response |



## Examples

```fm = ForwardModel(ift_method="ifft2", x_max=25, dx=0.5, scale=1e-6, ___)``` creates a ```ForwardModel``` object that uses MATLAB's built in [`ifft2`](https://www.mathworks.com/help/matlab/ref/ifft2.html) method to solve the 2-D inverse Fourier transform, with spatial vectors ```x = y = -25:0.5:25``` in units of microns and spatial frequency vectors ```u = v = -2:0.04:2``` in units of inverse microns.

## See Also

