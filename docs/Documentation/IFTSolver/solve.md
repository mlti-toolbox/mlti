---
layout: docs
title: IFTSolver.solve Function Documentation
permalink: /Documentation/IFTSolver/solve
---

# solve

Solves the 2-D inverse Fourier transform

## Syntax
<a href="#d1"><code class="hang">T0tilde = <wbr>solve(<wbr>solver,<wbr>T0hat)</code></a>

## Description
<a id="d1"></a>
[`T0tilde`](#T0-argument)` = solve(`<wbr>[`solver`](#solver-argument)`,`<wbr>[`T0hat`](#T0hat-argument)`)` transforms `T0hat` using the 2-D inverse Fourier transform method specified by `solver`.

## Input Arguments
<details class="custom-details" id="solver-argument">
    <summary>
        <span class="summary-text">
            <b><code>solver</code> - Input <code>IFTSolver</code> object</b>
            <span class="subline">
              <a href="{{ '/Documentation/IFTSolver' | relative_url }}"><code>IFTSolver</code></a> object
            </span>
        </span>
    </summary>
    <div>
        <p>
            The input <code>IFTSolver</code> object specifies the 2-D inverse Fourier transform method and defines the spatial (<code>x</code>,<code>y</code>) and spatial-frequency (<code>u</code>,<code>v</code>) arguments.
        </p>
        <p>
            <b>Data Type:</b> <a href="{{ '/Documentation/IFTSolver' | relative_url }}"><code>IFTSolver</code></a>
        </p>
    </div>
</details>

<details class="custom-details" id="T0hat-argument">
    <summary>
        <span class="summary-text">
            <b><code>T0hat</code> - 3D Fourier-domain surface temperature</b>
            <span class="subline">
              complex matrix | symbolic expression
            </span>
        </span>
    </summary>
    <div>
      <p>
        The 3D Fourier-domain surface temperature—<code>T0hat</code> or \(\hat{T}_0(u,v,f)\)—is obtained by applying a 2D spatial Fourier transform over \(x\) and \(y\) and a temporal Fourier transform over \(t\), as follows.
      </p>
      <p>
        \(
          \hat{T}_0 \left(
            u,v,f
          \right)
          = \left.
            \mathcal{F}_{x,y,t} \left\{
              T \left(
                x,y,z,t
              \right)
            \right\}
          \right|_{z=0}
        \)
      </p>
      <p>
        If <code>solver.method = "integral2"</code>, then <code>T0hat</code> must be a symbolic expression of <code>u</code>, <code>v</code>, and <code>f</code>.
      </p>
      <p>
        If <code>solver.method = "ifft2"</code>, then <code>T0hat</code> must be an \(N_x \times N_y \times N_T \times N_\mathrm{pump} \times N_f\) matrix or compatible in size.
      </p>
      <p>
        <b>Data Types:</b> <code>double</code> | <code>single</code> | <code>sym</code>
      </p>
    </div>
</details>

## Output Arguments
<details class="custom-details" id="T0-argument">
    <summary>
        <span class="summary-text">
            <b><code>T0tilde</code> - Phasor surface temperature</b>
            <span class="subline">
              complex matrix
            </span>
        </span>
    </summary>
    <div>
        <p>
            The phasor surface temperature—<code>T0tilde</code> or \(\tilde{T}_0(x,y,f)—is the temporal Fourier-transformed temperature evaluated at \(z=0\). It is obtained by performing a 2D inverse Fourier transform on \(\hat{T}_0\) over parameters \(u\) and \(v\), as follows.
        </p>
        <p>
            \(
                \tilde{T}_0 \left(
                    x,y,f
                \right)
                = \left.
                    \mathcal{F}_t \left\{
                        T \left(
                            x,y,z,t
                        \right)
                    \right\}
                \right|_{z=0}
                = \mathcal{F}^{-1}_{u,v} \left(
                    \hat{T}_0(u,v,f)
                \right)
            \)
        </p>
        <p>
            If <code>solver.method = "ifft2"</code> and <code>X_probe</code> is not provided, <code>T0tilde</code> is an \(N_x \times N_y \times N_T \times N_\mathrm{pump} \times N_f\) matrix and is the exact output of <code><a href="https://www.mathworks.com/help/releases/R2025a/matlab/ref/fftshift.html">fftshift</a>(<wbr>ifft2(<wbr>ifftshift(<wbr>T0hat)))</code>.
            </code><a href="https://www.mathworks.com/help/releases/R2025a/matlab/ref/fftshift.html"><code>fftshift</code></a><code>
                </code><a href="https://www.mathworks.com/help/releases/R2025a/matlab/ref/ifftshift.html"><code>ifftshift</code></a><code>
                    </code><a href="https://www.mathworks.com/help/releases/R2025a/matlab/ref/ifft2.html"><code>ifft2</code></a><code>
        </p>
        <p>
            if <code>X_probe</code> is provided, 
        </p>
        <p>
            <b>Data Type:</b> <code>double</code>
        </p>
    </div>
</details>

## Examples

## See Also
### MLTI Companion Classes and Methods
[`!!!NAME!!!`](!!!PATH!!!)

### MATLAB Built-in Methods

### MATLAB Topics
