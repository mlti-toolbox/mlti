# ForwardModel

Construct a ```ForwardModel``` object.

## Syntax

```
fm = ForwardModel(Name, Value)
```

## Description

```fm = ForwardModel(Name, Value)```

---

```fm = ForwardModel(Name, Value)```

## Examples

## Input Arguments

### Name-Value Arguments

<details>
  <summary><b>
    <code>ift_method</code> - 2-D inverse Fourier transform method
  </b></summary>

  <br>

  2-D inverse Fourier transform method.
  When possible, the [`ifft2`](https://www.mathworks.com/help/matlab/ref/ifft2.html) method should be used for its computational efficiency.
  However, if greater accuracy is needed, the [`integral2`](https://www.mathworks.com/help/matlab/ref/integral2.html) method may be used instead.
  
  **Value Options:** `'ifft2'` (default) | `'integral2'`
    
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
  Specifying a value for `x_max` is required when `ift_method = 'ifft2'`.

  **Value Options:** positive scalar value
    
  **Data Types:** `double`
  
  <br>
  
</details>

<details>
  <summary><b>
    <code>x_N</code> - number of spatial steps
  </b></summary>

  <br>

  Number of descrete spatial steps between `x_pump` and $\pm$`x_max`.
  I.e., size of the data array will be `2 * x_N + 1`-by-`2 * x_N + 1`.

  **Value Options:** 100 (default) | positive scalar value
    
  **Data Types:** `double`

  <br>
  
</details>

<details>
  <summary><b>
    <code>x_step</code> - step size
  </b></summary>

  <br>

  Descrete spatial step size between `x_pump` and $\pm$`x_max`.
  If both `x_N` and `x_step` are provided as inputs, `x_step` takes priority.

  **Value Options:** positive scalar value
    
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
  Required when either `film_orient` or `sub_orient` is set to `'euler'`.
  
  **Value Options:** `'ZYZ'` (default) | `'ZXZ'` | `'ZYX'` | `'ZXY'` | `'YXY'` | `'YZY'` | `'YXZ'` | `'YZX'` | `'XYX'` | `'XZX'` | `'XYZ'` | `'XZY'` |
    
  **Data Types:** `char` | `string`

  <br>
  
</details>

<details>
  <summary><b>
    <code>inf_sub_thick</code> - use infinite substrate thickness approximation
  </b></summary>

  <br>

  When set to `true`, approximates the thickness of the substrate as infinite in the z-direction.
  Approximating the substrate thickness as infinite is more numerically stable.
  
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

## Output Arguments

## See Also