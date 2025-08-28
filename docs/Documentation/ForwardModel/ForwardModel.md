---
layout: docs
title: ForwardModel
permalink: /Documentation/ForwardModel
---

# ForwardModel

Models the surface thermal response induced by a laser heat source with Gaussian spatial distribution and harmonic temporal modulation.

## Description
<p>
The <code>ForwardModel</code> class predicts the surface thermal response induced by a pump laser heat source with Gaussian spatial distribution and harmonic temporal modulation. Specifically, it returns the phase lag \(\mathbf{\upphi}\), amplitude \(\mathbf{A}\), and DC temperature rise \(\Delta\mathbf{T}_\mathrm{DC}\) at specific probe offsets \(\mathbf{X}_\mathrm{probe}\) within some error \(\mathbf{\upepsilon}_T\).
</p>
<p>
\({\left\{\mathbf{\upphi}, \mathbf{A}, \Delta\mathbf{T}_\mathrm{DC}\right\}} = {G\left(\mathbf{M}, \mathbf{O}, \chi, \mathbf{f}_0, \mathbf{X}_\mathrm{probe}\right) + \mathbf{\upepsilon}_T}\)
</p>
<p>
Where
</p>
<ul>
    <li>\(G\left(...\right)\) represents the forward model function.</li>
    <li>\(\mathbf{M}\) is an array of material parameters</li>
    <li>\(\mathbf{O}\) is an array of orientation parameters</li>
    <li>\(\chi\) is an array of experimental parameters</li>
    <li>\(\mathbf{f}_0\) is an array of pump laser frequencies</li>
    <li>\(\mathbf{X}_\mathrm{probe}\) is an array of probe offsets</li>
</ul>

See [`ForwardModel.solve`](/MLTI/Documentation/ForwardModel/solve) for more details.

<p>
The sample is expected to consist of a substrate layer and a thin film layer, modeled as semi-infinite in the \(x\)- and \(y\)-directions. Furthermore, the top surface of the sample \(\left(z=0\right)\) is modeled as insulated.
</p>

## Creation

### Syntax

<hr>

[`fm = ForwardModel(film,substrate,Name,Value)`](#d1)<br>

### Description

<a id="d1"></a>

<hr>

`fm = ForwardModel(`[`film`](#film-argument)`,`[`substrate`](#substrate-argument)`,`[`Name, Value`](#name-value-arguments)`)` creates a `ForwardModel` object according to user specifications. `film` and `substrate` are [`Layer`](/MLTI/Documentation/Layer) objects that specify how thermal conductivity will be represented in their respective layers. Name-value arguments specify which solving methods and approximations to use.

### Input Arguments

<details class="custom-details" id="film-argument">
    <summary>
        <span class="summary-text">
            <b><code>film</code> - Film layer specifications</b>
            <span class="subline">
                <a href="{{ '/Documentation/Layer' | relative_url }}"><code>Layer</code></a> object
            </span>
        </span>
    </summary>
    <div>
        <p>
            The <code>film</code> arguments is a <a href="{{ '/Documentation/Layer' | relative_url }}"><code>Layer</code></a> object that specifies how thermal conductivity is represented for the thin film layer of the sample.
        </p>
        <p>
            <b>Data Types:</b> <a href="{{ '/Documentation/Layer' | relative_url }}"><code>Layer</code></a>
        </p>
    </div>
</details>

<details class="custom-details" id="substrate-argument">
    <summary>
        <span class="summary-text">
            <b><code>substrate</code> - Substrate layer specifications</b>
            <span class="subline">
                <a href="{{ '/Documentation/Layer' | relative_url }}"><code>Layer</code></a> object
            </span>
        </span>
    </summary>
    <div>
        <p>
            The <code>substrate</code> arguments is a <a href="{{ '/Documentation/Layer' | relative_url }}"><code>Layer</code></a> object that specifies how thermal conductivity is represented for the substrate layer of the sample.
        </p>
        <p>
            <b>Data Types:</b> <a href="{{ '/Documentation/Layer' | relative_url }}"><code>Layer</code></a>
        </p>
    </div>
</details>

#### Name-Value Arguments

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
            <li>
                \(
                    {\left[ h_f \right]}
                    = {\left[ h_s \right]}
                    = {\left[ s_x \right]}
                    = {\left[ s_y \right]}
                    = {\left[ x_\mathrm{probe} \right]}
                    = {\mathrm{scale} \cdot \mathrm{m}}
                \)
            </li>
            <li>
                \(
                    {\left[ \alpha_f \right]}
                    = {\left[ \alpha_s \right]}
                    = {\left[ u \right]}
                    = {\left[ v \right]}
                    = {\left[\frac{1}{ x_\mathrm{probe}} \right]}
                    = {\frac{1}{\mathrm{scale} \cdot \mathrm{m}}}
                \)
            </li>
            <li>
                \(
                    {\left[C_f\right]}
                    = {\left[C_s\right]}
                    = {\frac{\mathrm{W}}{\mathrm{scale} \cdot \mathrm{m}^3 \cdot \mathrm{K}}}
                \)
            </li>
            <li>
                \(
                    {\left[ P \right]}
                    = {\mathrm{scale} \cdot \mathrm{W}}
                \)
            </li>
            <li>
                \(
                    {\left[ f_0 \right]}
                    = {\frac{\mathrm{Hz}}{\mathrm{scale}}}
                \)
            </li>
        </ul>
        <p>
            <b>Example:</b> If <code>scale = 1e-6</code> forward model inputs are considered to be in the following units:
        </p>
        <ul>
            <li>
                \(
                    {\left[ h_f \right]}
                    = {\left[ h_s \right]}
                    = {\left[ s_x \right]}
                    = {\left[ s_y \right]}
                    = {\left[ x_\mathrm{probe} \right]}
                    = {\mathrm{scale} \cdot \mathrm{m}}
                    = {10^{-6} \cdot \mathrm{m}}
                    = {\mathrm{\upmu m}}
                \)
            </li>
            <li>
                \(
                    {\left[ \alpha_f \right]}
                    = {\left[ \alpha_s \right]}
                    = {\left[ u \right]}
                    = {\left[ v \right]}
                    = {\left[\frac{1}{ x_\mathrm{probe}} \right]}
                    = {\frac{1}{\mathrm{scale} \cdot \mathrm{m}}}
                    = {\frac{1}{10^{-6} \cdot \mathrm{m}}}
                    = {\frac{1}{\mathrm{\upmu m}}}
                \)
            </li>
            <li>
                \(
                    {\left[C_f\right]}
                    = {\left[C_s\right]}
                    = {\frac{\mathrm{W}}{\mathrm{scale} \cdot \mathrm{m}^3 \cdot \mathrm{K}}}
                    = {\frac{\mathrm{W}}{10^{-6} \cdot \mathrm{m}^3 \cdot \mathrm{K}}}
                    = {\frac{\mathrm{W}}{\mathrm{cm}^3 \cdot \mathrm{K}}}
                \)
            </li>
            <li>
                \(
                    {\left[ P \right]}
                    = {\mathrm{scale} \cdot \mathrm{W}}
                    = {10^{-6} \cdot \mathrm{W}}
                    = {\mathrm{\upmu W}}
                \)
            </li>
            <li>
                \(
                    {\left[ f_0 \right]}
                    = {\frac{\mathrm{Hz}}{\mathrm{scale}}}
                    = {\frac{\mathrm{Hz}}{10^{-6}}}
                    = {10^6 \cdot \mathrm{Hz}}
                    = {\mathrm{MHz}}
                \)
            </li>
        </ul>
        <p>
            <b>Data Types:</b> <code>double</code> | <code>single</code>
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

### Examples
<a id="constructor-ex1"></a>

## Properties

<details class="custom-details">
    <summary>
        <span class="summary-text">
            <b><code>c_args</code> - Constructor arguments</b>
            <span class="subline">
                <code>struct</code>
            </span>
        </span>
    </summary>
    <div>
        <p>
            <code>c_args</code> is a struct of validated constructor arguments (input and default) populated by <code>validate_c_args</code>, a private <code>ForwardModel</code> method.
        </p>
    </div>
</details>

<details class="custom-details">
    <summary>
        <span class="summary-text">
            <b><code>fun_inputs</code> - Function input format specifications</b>
            <span class="subline">
                <code>struct</code>
            </span>
        </span>
    </summary>
    <div>
        <p>
            Struct of format specifications for method inputs <code>M</code>, <code>O</code>, <code>chi</code>, <code>f0</code>, and <code>X_probe</code> (used in <a href="{{ '/Documentation/ForwardModel/plot' | relative_url }}"><code>ForwardModel.plot</code></a> and <a href="{{ '/Documentation/ForwardModel/solve' | relative_url }}"><code>ForwardModel.solve</code></a>).
        </p>
        <p>
            Each field value is another struct with the following fields:
        </p>
        <ul>
            <li>
                ncols: Number of columns
            </li>
            <li>
                cols: 1-by-<code>ncols</code> string array; Specifies the variable name associated with each column of <code>M</code>.
            </li>
            <li>
                units: 1-by-<code>ncols</code> string array; Specifies the units of each column of <code>M</code>. If <code>c_args.log_args</code> is <code>true</code>, these units refer to the values before log-transformation, since the transformation implicitly normalizes by the base unit, yielding a unitless quantity.
            </li>
            <li>
                msg: A formatted string message for displaying the values of <code>ncols</code>, <code>cols</code>, and <code>units</code> to the screen.
            </li>
            <li>
                vld: Input validation function handle.
            </li>
        </ul>
        <p>
            <code>fun_inputs</code> is populated by <code>get_input_structure</code>, a private <code>ForwardModel</code> method.
        </p>
        <h3>Function Inputs Nomenclature</h3>
        {% include_relative fun_in_nomenclature.html %}
    </div>
</details>

<details class="custom-details">
    <summary>
        <span class="summary-text">
            <b><code>xu</code> - FFT spatial and spatial-frequency domains</b>
            <span class="subline">
                real 2-column matrix
            </span>
        </span>
    </summary>
    <div>
        <p>
            2-column matrix where the 1st column is the descretized spatial vector, and the 2nd column is the descretized spatial-frequency vector referenced when <code>ift_method="ifft2"</code>.
        </p>
    </div>
</details>

## Object Functions
<table>
  <tbody>
    <tr>
        <td>
            <a href="{{ '/Documentation/ForwardModel/plot' | relative_url }}"><code>plot</code></a>
        </td>
        <td>
            Plots the surface thermal response
        </td>
    </tr>
    <tr>
        <td>
            <a href="{{ '/Documentation/ForwardModel/solve' | relative_url }}"><code>solve</code></a>
        </td>
        <td>
            Solves the forward model
        </td>
    </tr>
  </tbody>
</table>

## Examples

## See Also
### ForwardModel methods

[`ForwardModel.plot`](/MLTI/Documentation/ForwardModel/plot) |
[`ForwardModel.solve`](/MLTI/Documentation/ForwardModel/solve)

### Companion Classes and Functions

### MATLAB built-ins
[`ifft2`](https://www.mathworks.com/help/matlab/ref/ifft2.html) |
[`integral2`](https://www.mathworks.com/help/matlab/ref/integral2.html) |
[`ndgrid`](https://www.mathworks.com/help/matlab/ref/ndgrid.html) |
[`validatestring`](https://www.mathworks.com/help/matlab/ref/validatestring.html)




