---
layout: docs
title: toTensor Function Documentation
permalink: /Documentation/Layer/toTensor
---

# toTensor

Converts user inputs to tensor representation.

## Syntax

<a href="#d1">
<code class="hang">[k11,<wbr>k21,<wbr>k31,<wbr>k22,<wbr>k32,<wbr>k33] = <wbr>toTensor(<wbr>layer,<wbr>&lt;layer.inputStr&gt;)</code>
</a><br>
<a href="#d2">
<code class="hang">[k11,<wbr>k21,<wbr>k31,<wbr>k22,<wbr>k32,<wbr>k33] = <wbr>toTensor(<wbr>layer,<wbr>&lt;layer.inputStr&gt;,<wbr>transform)</code>
</a>

Where `layer.inputStr` specifies a variable number of inputs, dependent on `layer.isotropy` and `layer.orient`. The following are specific cases.

<details>
<summary>Isotropic</summary>
<a href="#d3"><code class="hang">toTensor(<wbr>layer,<wbr>k)</code></a>
</details>

<details>
<summary>Uniaxial anisotropy, azimuthal/polar angle orientation</summary>
<a href="#d4"><code class="hang">toTensor(<wbr>layer,<wbr>k⊥,<wbr>k∥,<wbr>θ_az,<wbr>θ_pol)</code></a>
</details>

<details>
<summary>Uniaxial anisotropy, unit vector orientation</summary>
<a href="#d5"><code class="hang">toTensor(<wbr>layer,<wbr>k⊥,<wbr>k∥,<wbr>v1,<wbr>v2,<wbr>v3)</code></a>
</details>

<details>
<summary>Principal anisotropy, Euler angle orientation</summary>
<a href="#d6"><code class="hang">toTensor(<wbr>layer,<wbr>kp1,<wbr>kp2,<wbr>kp3,<wbr>θa1,<wbr>θb2,<wbr>θc3)</code></a>
</details>

<details>
<summary>Principal anisotropy, unit quaternion orientation</summary>
<a href="#d7"><code class="hang">toTensor(<wbr>layer,<wbr>kp1,<wbr>kp2,<wbr>kp3,<wbr>q1,<wbr>q2,<wbr>q3,<wbr>q4)</code></a>
</details>

<details>
<summary>Principal anisotropy, rotation matrix orientation</summary>
<a href="#d8"><code class="hang">toTensor(<wbr>layer,<wbr>kp1,<wbr>kp2,<wbr>kp3,<wbr>R11,<wbr>R21,<wbr>R31,<wbr>R12,<wbr>R22,<wbr>R32,<wbr>R13,<wbr>R23,<wbr>R33)</code></a>
</details>

<details>
<summary>Tensor anisotropic</summary>
<a href="#d9"><code class="hang">toTensor(<wbr>layer,<wbr>k11,<wbr>k21,<wbr>k31,<wbr>k22,<wbr>k32,<wbr>k33)</code></a>
</details>

## Description
<a id="d1"></a>
`[`[`k11,k21,k31,k22,k32,k33`](#output-arguments)`] = toTensor(`[`layer`](#layer-argument)`,`[`<layer.inputStr>`](#inputStr-arguments)`)` converts user-input thermal conductivity and orientation variables to tensor representation.
<hr>
<a id="d2"></a>
`[___] = toTensor(___, `[`transform`](#transform-argument)`)` applies the function specified by `transform` to strictly-positive thermal conductivity variables (`k`, `k⊥`, `k∥`, `kp1`, `kp2`, `kp3`, `k11`, `k22`, `k33`) provided by the user, and then converts these transformed inputs along with any orientation variables into the full tensor representation.

## Input Arguments

<details class="custom-details" id="layer-argument">
    <summary>
        <span class="summary-text">
            <b><code>layer</code> - Input layer object</b>
            <span class="subline">
                <a href="{{ '/Documentation/Layer' | relative_url }}"><code>Layer</code></a> object
            </span>
        </span>
    </summary>
    <div>
        <p>
            The input layer object defines the thermal conductivity of a material layer—whether isotropic, uniaxially anisotropic, or fully anisotropic—and specifies how conductivity is expressed in user inputs.
        </p>
        <p>
            <b>Data Type:</b> <a href="{{ '/Documentation/Layer' | relative_url }}"><code>Layer</code></a>
        </p>
    </div>
</details>

<details class="custom-details" id="transform-argument">
  <summary>
    <span class="summary-text">
      <b><code>transform</code> – Transformation function</b>
      <span class="subline">function handle</span>
    </span>
  </summary>
  <div>
    <p>
      The transformation function is applied to all strictly positive thermal conductivity variables 
      (<code>k</code>, <code>k⊥</code>, <code>k∥</code>, <code>kp1</code>, <code>kp2</code>, <code>kp3</code>, 
      <code>k11</code>, <code>k22</code>, <code>k33</code>) provided by the user before converting them to tensor representation.
    </p>
    <p>
      The typical use case is the exponential transformation 
      (<code>@(x) exp(x)</code>) when <code>log_args</code> is <code>true</code> inside the 
      <a href="{{ '/Documentation/ForwardModel' | relative_url }}"><code>ForwardModel</code></a>. 
      However, any function handle may be provided. Remember that the transformation is applied only to the thermal conductivity variables listed above.
    </p>
    <p>
      <b>Data Type:</b> <code>function_handle</code>
    </p>
  </div>
</details>

<h2 id="inputStr-arguments"><code>&lt;layer.inputStr&gt;</code> Arguments</h2>
<p>
  The number and names of the variables represented by <code>&lt;layer.inputStr&gt;</code> are determined when the <code>layer</code> object is constructed. 
  <code>layer.inputStr</code> is a string array and may include the following variable names:
</p>

### Conductivity Arguments:

<details class="custom-details" id="k-argument">
    <summary>
        <span class="summary-text">
            <b><code>k</code> - Isotropic conductivity</b>
            <span class="subline">
                \(N_T \times 1\) real vector | \(N_T \times N_\mathrm{pump}\) real matrix
            </span>
        </span>
    </summary>
    <div>
        <p>
            {{ site.data.nomenclature.k.codeSymbol | safe }} is the {{ site.data.nomenclature.k.description | safe }}
        </p>
        <p>
            <b>Data Types:</b> double | single
        </p>
    </div>
</details>

<details class="custom-details" id="k_perp-argument">
    <summary>
        <span class="summary-text">
            <b><code>{{ site.data.nomenclature.k_perp.codeSymbol | safe }}</code> - Transverse conductivity</b>
            <span class="subline">
                \(N_T \times 1\) real vector | \(N_T \times N_\mathrm{pump}\) real matrix
            </span>
        </span>
    </summary>
    <div>
        <p>
            {{ site.data.nomenclature.k_perp.codeSymbol | safe }} is the {{ site.data.nomenclature.k_perp.description | safe }}
        </p>
        <p>
            <b>Data Types:</b> double | single
        </p>
    </div>
</details>

<details class="custom-details" id="k_par-argument">
    <summary>
        <span class="summary-text">
            <b><code>{{ site.data.nomenclature.k_par.codeSymbol | safe }}</code> - Axial conductivity</b>
            <span class="subline">
                \(N_T \times 1\) real vector | \(N_T \times N_\mathrm{pump}\) real matrix
            </span>
        </span>
    </summary>
    <div>
        <p>
            {{ site.data.nomenclature.k_par.codeSymbol | safe }} is the {{ site.data.nomenclature.k_par.description | safe }}
        </p>
        <p>
            <b>Data Types:</b> double | single
        </p>
    </div>
</details>

<details class="custom-details" id="kpi-argument">
    <summary>
        <span class="summary-text">
            <b><code>{{ site.data.nomenclature.kpi.codeSymbol | safe }}</code> - \(i\)-th principal conductivity</b>
            <span class="subline">
                \(N_T \times 1\) real vector | \(N_T \times N_\mathrm{pump}\) real matrix
            </span>
        </span>
    </summary>
    <div>
        <p>
            {{ site.data.nomenclature.kpi.codeSymbol | safe }} is the {{ site.data.nomenclature.kpi.description | safe }}
        </p>
        <p>
            <b>Data Types:</b> double | single
        </p>
    </div>
</details>

<details class="custom-details" id="kij-argument">
    <summary>
        <span class="summary-text">
            <b><code>{{ site.data.nomenclature.kij.codeSymbol | safe }}</code> - \((i,j)\)-th tensor component</b>
            <span class="subline">
                \(N_T \times 1\) real vector | \(N_T \times N_\mathrm{pump}\) real matrix
            </span>
        </span>
    </summary>
    <div>
        <p>
            {{ site.data.nomenclature.kij.codeSymbol | safe }} is the {{ site.data.nomenclature.kij.description | safe }}
        </p>
        <p>
            <b>Data Types:</b> double | single
        </p>
    </div>
</details>

### Orientation Arguments:

<details class="custom-details" id="az-argument">
    <summary>
        <span class="summary-text">
            <b><code>{{ site.data.nomenclature.az.codeSymbol | safe }}</code> - Azimuthal angle</b>
            <span class="subline">
                \(1 \times N_\mathrm{pump}\) real vector
            </span>
        </span>
    </summary>
    <div>
        <p>
            {{ site.data.nomenclature.az.codeSymbol | safe }} is the {{ site.data.nomenclature.az.description | safe }}
        </p>
        <p>
            <b>Data Types:</b> double | single
        </p>
    </div>
</details>

<details class="custom-details" id="pol-argument">
    <summary>
        <span class="summary-text">
            <b><code>{{ site.data.nomenclature.pol.codeSymbol | safe }}</code> - Polar angle</b>
            <span class="subline">
                \(1 \times N_\mathrm{pump}\) real vector
            </span>
        </span>
    </summary>
    <div>
        <p>
            {{ site.data.nomenclature.pol.codeSymbol | safe }} is the {{ site.data.nomenclature.pol.description | safe }}
        </p>
        <p>
            <b>Data Types:</b> double | single
        </p>
    </div>
</details>

<details class="custom-details" id="vi-argument">
    <summary>
        <span class="summary-text">
            <b><code>{{ site.data.nomenclature.vi.codeSymbol | safe }}</code> - \(i\)-th unit vector component angle</b>
            <span class="subline">
                \(1 \times N_\mathrm{pump}\) real vector
            </span>
        </span>
    </summary>
    <div>
        <p>
            {{ site.data.nomenclature.vi.codeSymbol | safe }} is the {{ site.data.nomenclature.vi.description | safe }}
        </p>
        <p>
            <b>Data Types:</b> double | single
        </p>
    </div>
</details>

<details class="custom-details" id="eul-argument">
    <summary>
        <span class="summary-text">
            <b><code>{{ site.data.nomenclature.eul.codeSymbol | safe }}</code> - \(i\)-th Euler angle</b>
            <span class="subline">
                \(1 \times N_\mathrm{pump}\) real vector
            </span>
        </span>
    </summary>
    <div>
        <p>
            {{ site.data.nomenclature.eul.codeSymbol | safe }} is the {{ site.data.nomenclature.eul.description | safe }}
        </p>
        <p>
            <b>Data Types:</b> double | single
        </p>
    </div>
</details>

<details class="custom-details" id="q-argument">
    <summary>
        <span class="summary-text">
            <b><code>{{ site.data.nomenclature.qi.codeSymbol | safe }}</code> - \(i\)-th quaterionion component</b>
            <span class="subline">
                \(1 \times N_\mathrm{pump}\) real vector
            </span>
        </span>
    </summary>
    <div>
        <p>
            {{ site.data.nomenclature.qi.codeSymbol | safe }} is the {{ site.data.nomenclature.qi.description | safe }}
        </p>
        <p>
            <b>Data Types:</b> double | single
        </p>
    </div>
</details>

<details class="custom-details" id="R-argument">
    <summary>
        <span class="summary-text">
            <b><code>{{ site.data.nomenclature.R.codeSymbol | safe }}</code> - \((i,j)\)-th rotation matrix component</b>
            <span class="subline">
                \(1 \times N_\mathrm{pump}\) real vector
            </span>
        </span>
    </summary>
    <div>
        <p>
            {{ site.data.nomenclature.Rij.codeSymbol | safe }} is the {{ site.data.nomenclature.Rij.description | safe }}
        </p>
        <p>
            <b>Data Types:</b> double | single
        </p>
    </div>
</details>

## Output Arguments
<details class="custom-details" id="kij-output-argument">
    <summary>
        <span class="summary-text">
            <b><code>kij</code> - \((i,j)\)-th tensor component</b>
            <span class="subline">
                \(N_T \times 1\) real vector | \(N_T \times N_\mathrm{pump}\) real matrix
            </span>
        </span>
    </summary>
    <div>
        <p>
            kij is the {{ site.data.nomenclature.kij.description | safe }}
        </p>
        <p>
            <b>Data Types:</b> double | single
        </p>
    </div>
</details>

## Examples

## See Also
