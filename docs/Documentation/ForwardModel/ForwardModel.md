---
layout: docs
title: ForwardModel
hyperlink: /Documentation/ForwardModel
---

# ForwardModel

Models the surface thermal response induced by a laser heat source with Gaussian spatial distribution and harmonic temporal modulation.

## Description
<p>
The <code>ForwardModel</code> class predicts the surface thermal response induced by a laser heat source with Gaussian spatial distribution and harmonic temporal modulation. Specifically, it returns the phase lag \(\mathbf{\upphi}\), amplitude \(\mathbf{A}\), and DC temperature rise \(\Delta\mathbf{T}_\mathrm{DC}\) at specific probe offsets \(\mathbf{X}_\mathrm{probe}\) within some error \(\mathbf{\upepsilon}_T\).
\[\left\{\mathbf{\upphi}, \mathbf{A}, \Delta\mathbf{T}_\mathrm{DC}\right\} = G\left(\mathbf{M}, \mathbf{\Theta}, \chi, \mathbf{f}_0, \mathbf{X}_\mathrm{probe}\right) + \epsilon_T\]
Where \(G\left(...\right)\) represents the forward model function. See <a href="/MLTI/Documentation/ForwardModel/solve"><code>ForwardModel.solve</code></a> for more details.
</p>
<p>
The sample is expected to consist of a substrate layer and a thin film layer, modeled as semi-infinite in the \(x\)- and \(y\)-directions. Furthermore, the top surface of the sample \(\left(z=0\right)\) is modeled as insulated.
</p>

## Creation

### Syntax
```matlab
fm = ForwardModel(Name, Value)
```

### Description

`fm = ForwardModel(Name, Value)` creates a forward model object according to specifications provided as name-value arguments.

### Input (Name-Value) Arguments

Specify name–value pairs as `Name1=Value1, ..., NameN=ValueN`, where each `Name` is an argument name and each `Value` is the corresponding value. The order of the pairs does not matter.  

Argument names are validated using [`validatestring`](https://www.mathworks.com/help/matlab/ref/validatestring.html), making them **case-insensitive**. You can also use any unique leading substring of the name. For example, the name `"ift"` matches the option `"ift_method"`.

*Before R2021a, separate each name and value with commas and enclose* `Name` *in quotes.*  

**Example:**  
```matlab
fm = ForwardModel(ift_method="ifft2", x_max=25, dx=0.5, scale=1e-6)
% Equivalent pre-R2021a syntax:
fm = ForwardModel('ift_method', "ifft2", 'x_max', 25, 'dx', 0.5, 'scale', 1e-6)
```

<details class="custom-details">
    <summary>
        <span class="summary-text">
            <b><code>ift_method</code> - 2-D inverse Fourier transform method</b>
            <span class="subline"><code>"ifft2"</code> (default) | <code>"integral2"</code></span>
        </span>
    </summary>
    <div>
        <p>
            2-D inverse Fourier transform method. When possible, the
            <a href="https://www.mathworks.com/help/matlab/ref/ifft2.html"><code>ifft2</code></a>
            method should be used for its computational efficiency.
            However, if greater accuracy is needed, the
            <a href="https://www.mathworks.com/help/matlab/ref/integral2.html"><code>integral2</code></a>
            method may be used instead.
        </p>
        <p>
            When <code>ift_method = "ifft2"</code>, either
            <code>x_max</code> or <code>dx</code> must be provided.
            <code>Nx</code> has a default value, but <code>x_max</code>
            and <code>dx</code> do not. At least two of the three
            (<code>x_max</code>, <code>Nx</code>, <code>dx</code>)
            must be known to compute the third.
        </p>
        <p>
            Input value is validated using
            <a href="https://www.mathworks.com/help/matlab/ref/validatestring.html"><code>validatestring</code></a>.
        </p>
        <p>
            <b>Data Types:</b> <code>char</code> | <code>string</code>
        </p>
    </div>
</details>

<details class="custom-details">
    <summary>
        <span class="summary-text">
            <b><code>x_max</code> - Maximum spatial distance from pump</b>
            <span class="subline">positive real scalar</span>
        </span>
    </summary>
    <div>
        <p>
            Maximum spatial distance from the pump in the x- and y-directions used in the 2-D inverse fast Fourier transform
            (<a href="https://www.mathworks.com/help/matlab/ref/ifft2.html"><code>ifft2</code></a>).
            When specified, the spatial domain for both <code>x_probe</code>
            and <code>y_probe</code> will be <code>[-x_max, x_max]</code>
            if <code>dx</code> is also specified or if <code>Nx</code> is odd;
            otherwise (<code>Nx</code> is even), the domain will be <code>[-x_max, x_max - dx]</code>.
        </p>
        <p>
            The value of <code>x_max</code> is ignored when <code>ift_method = "integral2"</code>.
        </p>
        <p>
            <b>Data Types:</b> <code>double</code> | <code>single</code>
        </p>
    </div>
</details>

<details class="custom-details">
    <summary>
        <span class="summary-text">
            <b><code>Nx</code> - Number of spatial steps</b>
            <span class="subline"> 256 (default) | positive integer scalar</span>
        </span>
    </summary>
    <div>
        <p>
            Number of descrete spatial points to use in the
            <a href="https://www.mathworks.com/help/matlab/ref/ifft2.html"><code>ifft2</code></a>
            transform. I.e., signal length.
        </p>
        <p>
            When possible, the value of <code>Nx</code> should only have small prime factors as this results in significantly faster execution of the
            <a href="https://www.mathworks.com/help/matlab/ref/ifft2.html"><code>ifft2</code></a>
            transform.
        </p>
        <p>
            The value of <code>Nx</code> is ignored when <code>ift_method = "integral2"</code> or if all three <code>x_max</code>, <code>Nx</code>, and <code>dx</code> are specified.
        </p>
        <p>
            <b>Data Types:</b> <code>double</code> | <code>single</code> | <code>int8</code> | <code>int16</code> | <code>int32</code> | <code>uint8</code> | <code>uint16</code> | <code>uint32</code>
        </p>
    </div>
</details>

<details class="custom-details">
    <summary>
        <span class="summary-text">
            <b><code>dx</code> - Descrete spatial step size</b>
            <span class="subline"> positive real scalar</span>
        </span>
    </summary>
    <div>
        <p>
            Descrete spatial step size. I.e., sampling period.
        </p>
        <p>
            The value of <code>dx</code> is ignored when <code>ift_method = "integral2"</code>.
        </p>
        <p>
            <b>Data Types:</b> <code>double</code> | <code>single</code>
        </p>
    </div>
</details>

<details class="custom-details">
    <summary>
        <span class="summary-text">
            <b><code>scale</code> - Input scale factor</b>
            <span class="subline"> 1 (default) | positive real scalar</span>
        </span>
    </summary>
    <div>
        <p>
            The input scale factor defines the units of certain forward model inputs by scaling their base SI units as follows:
        </p>
        <ul>
            <li>\(\left[ h_f \right] = \left[ h_s \right] = \left[ s_x \right] = \left[ s_y \right] = \left[ x_\mathrm{probe} \right] = \mathrm{scale} \cdot \mathrm{m}\)</li>
            <li>\(\left[ \alpha_f \right] = \left[ \alpha_s \right] = \left[ u \right] = \left[ v \right] = \left[\frac{1}{ x_\mathrm{probe}} \right] = \frac{1}{\mathrm{scale} \cdot \mathrm{m}}\)</li>
            <li>\(\left[C_f\right] = \left[C_s\right] = \frac{\mathrm{W}}{\mathrm{scale} \cdot \mathrm{m}^3 \cdot \mathrm{K}}\)</li>
            <li>\(\left[ P \right] = \left[ \mathrm{scale} \cdot \mathrm{W} \right]\)</li>
            <li>\(\left[ f_0 \right] = \left[\frac{\mathrm{Hz}}{\mathrm{scale}} \right]\)</li>
        </ul>
        <p>
            <b>Example:</b> If <code>scale = 1e-6</code> forward model inputs are considered to be in the following units:
        </p>
        <ul>
            <li>\(\left[ h_f \right] = \left[ h_s \right] = \left[ s_x \right] = \left[ s_y \right] = \left[ x_\mathrm{probe} \right] = \mathrm{scale} \cdot \mathrm{m} = 10^{-6} \cdot \mathrm{m} = \mathrm{\upmu m}\)</li>
            <li>\(\left[ \alpha_f \right] = \left[ \alpha_s \right] = \left[ u \right] = \left[ v \right] = \left[\frac{1}{ x_\mathrm{probe}} \right] = \frac{1}{\mathrm{scale} \cdot \mathrm{m}} = \frac{1}{10^{-6} \cdot \mathrm{m}} = \frac{1}{\mathrm{\upmu m}}\)</li>
            <li>\(\left[C_f\right] = \left[C_s\right] = \frac{\mathrm{W}}{\mathrm{scale} \cdot \mathrm{m}^3 \cdot \mathrm{K}} = \frac{\mathrm{W}}{10^{-6} \cdot \mathrm{m}^3 \cdot \mathrm{K}} = \frac{\mathrm{W}}{\mathrm{cm}^3 \cdot \mathrm{K}}\)</li>
            <li>\(\left[ P \right] = \left[ \mathrm{scale} \cdot \mathrm{W} \right] = \left[ 10^{-6} \cdot \mathrm{W} \right] = \left[ \mathrm{\upmu W} \right]\)</li>
            <li>\(\left[ f_0 \right] = \left[\frac{\mathrm{Hz}}{\mathrm{scale}} \right] = \left[\frac{\mathrm{Hz}}{10^{-6}} \right] = \left[ 10^6 \cdot \mathrm{Hz} \right] = \left[ \mathrm{MHz} \right]\)</li>
        </ul>
        <p>
            <b>Data Types:</b> <code>double</code> | <code>single</code>
        </p>
    </div>
</details>

<details class="custom-details">
    <summary>
        <span class="summary-text">
            <b><code>film_isotropy</code> - Film isotropy type</b>
            <span class="subline"><code>"tensor"</code> (default) | <code>"iso"</code> | <code>"simple"</code> | <code>"complex"</code></span>
        </span>
    </summary>
    <div>
        <p>
            Film isotropy type specifies the isotropy level of the film.
        </p>
        <ul>
            <li><code>"iso"</code>: For scalar thermal conductivity <code>kf</code></li>
            <li><code>"simple"</code>: For 2 principal thermal conductivities along a specified axis <code>kf∥</code> and perpendicular to that axis <code>kf⊥</code></li>
            <li><code>"complex"</code>: For 3 principal thermal conductivities sorted in descending order <code>kfp1</code>, <code>kfp2</code>, <code>kfp3</code></li>
            <li><code>"tensor"</code>: For 6 element thermal conductivity tensor <code>kf11</code>, <code>kf12</code>, <code>kf13</code>, <code>kf22</code>, <code>kf23</code>, <code>kf33</code></li>
        </ul>
        <p>
            Input value is validated using
            <a href="https://www.mathworks.com/help/matlab/ref/validatestring.html"><code>validatestring</code></a>.
        </p>
        <p>
            <b>Data Types:</b> <code>char</code> | <code>string</code>
        </p>
    </div>
</details>

<details class="custom-details">
    <summary>
        <span class="summary-text">
            <b><code>sub_isotropy</code> - Substrate isotropy type</b>
            <span class="subline">
                <code>"tensor"</code> (default) | <code>"iso"</code> | <code>"simple"</code> | <code>"complex"</code>
            </span>
        </span>
    </summary>
    <div>
        <p>
            Substrate isotropy type specifies the isotropy level of the film.
        </p>
        <ul>
            <li><code>"iso"</code>: For scalar thermal conductivity <code>ks</code></li>
            <li><code>"simple"</code>: For 2 principal thermal conductivities along a specified axis <code>ks∥</code> and perpendicular to that axis <code>ks⊥</code></li>
            <li><code>"complex"</code>: For 3 principal thermal conductivities sorted in descending order <code>ksp1</code>, <code>ksp2</code>, <code>ksp3</code></li>
            <li><code>"tensor"</code>: For 6 element thermal conductivity tensor <code>ks11</code>, <code>ks12</code>, <code>ks13</code>, <code>ks22</code>, <code>ks23</code>, <code>kf33</code></li>
        </ul>
        <p>
            Input value is validated using
            <a href="https://www.mathworks.com/help/matlab/ref/validatestring.html"><code>validatestring</code></a>.
        </p>
        <p>
            <b>Data Types:</b> <code>char</code> | <code>string</code>
        </p>
    </div>
</details>

<details class="custom-details">
    <summary>
        <span class="summary-text">
            <b><code>film_orient</code> - Film orientation type</b>
            <span class="subline">
                <code>"azpol"</code> | <code>"uvect"</code> | <code>"euler"</code> | <code>"uquat"</code> | <code>"rotmat"</code>
            </span>
        </span>
    </summary>
    <div>
        <p>
            Film orientation type specifies how the principal axes orientations of the film are represented.
            Required when <code>film_isotropy</code> equals either <code>"simple"</code> or <code>"complex"</code>.
        </p>
        <ul>
            <li><code>"azpol"</code>: For representing the <code>kf∥</code> axis as azimuthal <code>θf1</code> and polar <code>θf2</code> angles. Use only when <code>film_isotropy = "simple"</code>.</li>
            <li><code>"uvect"</code>: For representing the <code>kf∥</code> axis as a unit vector <code>vf1</code>, <code>vf2</code>, <code>vf3</code>. Use only when <code>film_isotropy = "simple"</code>.</li>
            <li><code>"euler"</code>: For representing the orientation of the principal axes as Euler angles <code>θf1</code>, <code>θf2</code>, <code>θf3</code>.</li>
            <li><code>"uquat"</code>: For representing the orientation of the principal axes as a unit quaternion <code>qf1</code>, <code>qf2</code>, <code>qf3</code>, <code>qf4</code>.</li>
            <li><code>"rotmat"</code>: For representing the orientation of the principal axes as a rotation matrix <code>Rf11</code>, <code>Rf21</code>, <code>Rf31</code>, <code>Rf12</code>, <code>Rf22</code>, <code>Rf32</code>, <code>Rf13</code>, <code>Rf23</code>, <code>Rf33</code>.</li>
        </ul>
        <p>
            Input value is validated using
            <a href="https://www.mathworks.com/help/matlab/ref/validatestring.html"><code>validatestring</code></a>.
        </p>
        <p>
            <b>Data Types:</b> <code>char</code> | <code>string</code>
        </p>
    </div>
</details>

<details class="custom-details">
    <summary>
        <span class="summary-text">
            <b><code>sub_orient</code> - Substrate orientation type</b>
            <span class="subline">
                <code>"azpol"</code> | <code>"uvect"</code> | <code>"euler"</code> | <code>"uquat"</code> | <code>"rotmat"</code>
            </span>
        </span>
    </summary>
    <div>
        <p>
            Substrate orientation type specifies how the principal axes orientations of the film are represented.
            Required when <code>sub_isotropy</code> equals either <code>"simple"</code> or <code>"complex"</code>.
        </p>
        <ul>
            <li><code>"azpol"</code>: For representing the <code>ks∥</code> axis as azimuthal <code>θs1</code> and polar <code>θs2</code> angles. Use only when <code>sub_isotropy = "simple"</code>.</li>
            <li><code>"uvect"</code>: For representing the <code>ks∥</code> axis as a unit vector <code>vs1</code>, <code>vs2</code>, <code>vs3</code>. Use only when <code>sub_isotropy = "simple"</code>.</li>
            <li><code>"euler"</code>: For representing the orientation of the principal axes as Euler angles <code>θs1</code>, <code>θs2</code>, <code>θs3</code>.</li>
            <li><code>"uquat"</code>: For representing the orientation of the principal axes as a unit quaternion <code>qs1</code>, <code>qs2</code>, <code>qs3</code>, <code>qs4</code>.</li>
            <li><code>"rotmat"</code>: For representing the orientation of the principal axes as a rotation matrix <code>Rs11</code>, <code>Rs21</code>, <code>Rs31</code>, <code>Rs12</code>, <code>Rs22</code>, <code>Rs32</code>, <code>Rs13</code>, <code>Rs23</code>, <code>Rs33</code>.</li>
        </ul>
        <p>
            Input value is validated using
            <a href="https://www.mathworks.com/help/matlab/ref/validatestring.html"><code>validatestring</code></a>.
        </p>
        <p>
            <b>Data Types:</b> <code>char</code> | <code>string</code>
        </p>
    </div>
</details>

<details class="custom-details">
    <summary>
        <span class="summary-text">
            <b><code>euler_seq</code> - Euler angle sequence</b>
            <span class="subline">
                <code>"ZYZ"</code> (default) | <code>"ZXZ"</code> | <code>"ZYX"</code> | <code>"ZXY"</code> | <code>"YXY"</code> | <code>"YZY"</code> | <code>"YXZ"</code> | <code>"YZX"</code> | <code>"XYX"</code> | <code>"XZX"</code> | <code>"XYZ"</code> | <code>"XZY"</code>
            </span>
        </span>
    </summary>
    <div>
        <p>
            Euler angle sequence specified as three axes.
            I.e., computes the rotation matrix as \(\mathbf{R} = \mathbf{R}_i\left(\theta_1\right) \cdot \mathbf{R}_j\left(\theta_2\right) \cdot \mathbf{R}_k\left(\theta_3\right)\), where \(i, j, k \in \left\{x, y, z\right\}\) are the 1st, 2nd, and 3rd characters of the input character array, and:
        </p>
        <p>
            \(
            {\mathbf{R}_x(\theta) =
            \begin{bmatrix}
            1 & 0 & 0 \\
            0 & \cos\theta & -\sin\theta \\
            0 & \sin\theta & \cos\theta
            \end{bmatrix}},\,
            {\mathbf{R}_y(\theta) =
            \begin{bmatrix}
            \cos\theta & 0 & \sin\theta \\
            0 & 1 & 0 \\
            -\sin\theta & 0 & \cos\theta
            \end{bmatrix}},\,
            {\mathbf{R}_z(\theta) =
            \begin{bmatrix}
            \cos\theta & -\sin\theta & 0 \\
            \sin\theta & \cos\theta & 0 \\
            0 & 0 & 1
            \end{bmatrix}}
            \)
        </p>
        <p>
            Only referenced when either <code>film_orient</code> or <code>sub_orient</code> is set to <code>"euler"</code>.
        </p>
        <p>
            Input value is validated using
            <a href="https://www.mathworks.com/help/matlab/ref/validatestring.html"><code>validatestring</code></a>.
        </p>
        <p>
            <b>Data Types:</b> <code>char</code> | <code>string</code>
        </p>
    </div>
</details>

<details class="custom-details">
    <summary>
        <span class="summary-text">
            <b><code>sweep_method</code> - Method for iterating over parameter combinations</b>
            <span class="subline">
                <code>"broadcast"</code> (default) | <code>"ndgrid"</code> | <code>"loop"</code>
            </span>
        </span>
    </summary>
    <div>
        <p>
            Specifies how the solver will iterate over all combinations of input parameter sets <code>M_train</code>, <code>O</code>, <code>f0</code>, <code>x_probe</code> when computing the 4-D output array <code>G(i,j,k,l) = fm.solve(M_train(i,:), O(j,:), chi, f0(k,:), x_probe(l,:))</code>. This choice affects both memory usage and performance.
        </p>
        <ul>
            <li><code>"broadcast"</code> – Uses singleton expansion to apply <code>fm.solve(...)</code> over multi-dimensional parameter arrays without explicitly forming full grids in memory. Saves memory, but may be slower in some cases.</li>
            <li><code>"ndgrid"</code> – Expands all parameter arrays to full \(N_\mathrm{train} \times N_\mathrm{pump} \times N_f \times N_\mathrm{prope}\) grids
              using <a href="https://www.mathworks.com/help/matlab/ref/ndgrid.html"><code>ndgrid</code></a>. Fast for vectorized operations but uses the most
              memory.</li>
            <li><code>"loop"</code> – Iterates explicitly over all parameter combinations in nested <code>for</code> loops. Uses minimal memory but is typically the slowest
              method.</li>
        </ul>
        <p>
            Input value is validated using
            <a href="https://www.mathworks.com/help/matlab/ref/validatestring.html"><code>validatestring</code></a>.
        </p>
        <p>
            <b>Data Types:</b> <code>char</code> | <code>string</code>
        </p>
    </div>
</details>

<details class="custom-details">
    <summary>
        <span class="summary-text">
            <b><code>inf_sub_thick</code> - Use infinite substrate thickness approximation</b>
            <span class="subline">
                <code>true</code> (default) | <code>false</code>
            </span>
        </span>
    </summary>
    <div>
        <p>
            When set to <code>true</code>, approximates the thickness of the substrate as infinite in the z-direction, which is more numerically stable than using a finite substrate thickness.
        </p>
        <p>
            <b>Data Types:</b> <code>logical</code>
        </p>
    </div>
</details>

<details class="custom-details">
    <summary>
        <span class="summary-text">
            <b><code>phase_only</code> - Return phase only</b>
            <span class="subline">
                <code>false</code> (default) | <code>true</code>
            </span>
        </span>
    </summary>
    <div>
        <p>
            When set to <code>true</code>, tells the solver that the user is only interested in phase; not amplitude nor DC temperature change.
        </p>
        <p>
            <b>Data Types:</b> <code>logical</code>
        </p>
    </div>
</details>

<details class="custom-details">
    <summary>
        <span class="summary-text">
            <b><code>force_sym_solve</code> - Force reexecution of symbolic solution</b>
            <span class="subline">
                <code>false</code> (default) | <code>true</code>
            </span>
        </span>
    </summary>
    <div>
        <p>
            When set to <code>true</code>, forces the reexecution of the symbolic solutions even if the files already exist.
        </p>
        <p>
            <b>Data Types:</b> <code>logical</code>
        </p>
    </div>
</details>

<details class="custom-details">
    <summary>
        <span class="summary-text">
            <b><code>log_args</code> - Use log arguments</b>
            <span class="subline">
                <code>false</code> (default) | <code>true</code>
            </span>
        </span>
    </summary>
    <div>
        <p>
            When set to <code>true</code>, the solver expects the natural log of thermal conductivity, volumetric heat capacity, optical absorption coefficient, z-direction thickness, pump laser deviation, and power as inputs.
        </p>
        <p>
            <b>Data Types:</b> <code>logical</code>
        </p>
    </div>
</details>

### Examples

## Properties

<details class="custom-details">
  <summary><b>
    <code>c_args</code> - constructor arguments
  </b></summary>

  <br>

  Struct of input arguments passed into the constructor.
    
  **Data Types:** `struct`

  <br>
  
</details>

<details class="custom-details">
  <summary><b>
    <code>in_structure</code> - input structure
  </b></summary>

  <br>

  Specifies the expected input structure for `M`, `Theta`, and `chi` (inputs to `ForwardModel` functions).

  **Data Type:** 1-by-3 cell array, where each element is a string array

  **Example:** 

  <br>
  
</details>

<details class="custom-details">
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

















