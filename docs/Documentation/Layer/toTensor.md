---
layout: docs
title: toTensor Function Documentation
permalink: /Documentation/Layer/toTensor
---

# toTensor

Converts user inputs to tensor representation.

## Syntax
<a href="#d3">
    <code class="hang">toTensor(<wbr>layer,<wbr>k)</code>
</a>

<a href="#d4">
    <code class="hang">toTensor(<wbr>layer,<wbr>k⊥,<wbr>k∥,<wbr>θ_az,<wbr>θ_pol)</code>
</a><br>
<a href="#d5">
    <code class="hang">toTensor(<wbr>layer,<wbr>k⊥,<wbr>k∥,<wbr>v1,<wbr>v2,<wbr>v3)</code>
</a><br>
<a href="#d6">
    <code class="hang">toTensor(<wbr>layer,<wbr>k⊥,<wbr>k∥,<wbr>θa1,<wbr>θb2)</code>
</a><br>
<a href="#d7">
    <code class="hang">toTensor(<wbr>layer,<wbr>k⊥,<wbr>k∥,<wbr>q1,<wbr>q2,<wbr>q3,<wbr>q4)</code>
</a><br>
<a href="#d8">
    <code class="hang">toTensor(<wbr>layer,<wbr>k⊥,<wbr>k∥,<wbr>R11,<wbr>R21,<wbr>R31,<wbr>R12,<wbr>R22,<wbr>R32,<wbr>R13,<wbr>R23,<wbr>R33)</code>
</a>

<a href="#d6">
    <code class="hang">toTensor(<wbr>layer,<wbr>kp1,<wbr>kp2,<wbr>kp3,<wbr>θa1,<wbr>θb2,<wbr>θc3)</code>
</a><br>
<a href="#d7">
    <code class="hang">toTensor(<wbr>layer,<wbr>kp1,<wbr>kp2,<wbr>kp3,<wbr>q1,<wbr>q2,<wbr>q3,<wbr>q4)</code>
</a><br>
<a href="#d8">
    <code class="hang">toTensor(<wbr>layer,<wbr>kp1,<wbr>kp2,<wbr>kp3,<wbr>R11,<wbr>R21,<wbr>R31,<wbr>R12,<wbr>R22,<wbr>R32,<wbr>R13,<wbr>R23,<wbr>R33)</code>
</a>

<a href="#d9">
    <code class="hang">toTensor(<wbr>layer,<wbr>k11,<wbr>k21,<wbr>k31,<wbr>k22,<wbr>k32,<wbr>k33)</code>
</a>

<a href="#d1">
<code class="hang">[k11,<wbr>k21,<wbr>k31,<wbr>k22,<wbr>k32,<wbr>k33] = <wbr>toTensor(<wbr>layer,<wbr>&lt;layer.inputStr&gt;)</code>
</a><br>
<a href="#d2">
<code class="hang">[k11,<wbr>k21,<wbr>k31,<wbr>k22,<wbr>k32,<wbr>k33] = <wbr>toTensor(<wbr>layer,<wbr>&lt;layer.inputStr&gt;,<wbr>transform)</code>
</a>

Where `layer.inputStr` specifies a variable number of inputs, dependent on `layer.isotropy` and `layer.orient`.

**Example:**

If <code>layer.inputStr ==<wbr> ["k⊥",<wbr>"k∥",<wbr>"θ_az",<wbr>"θ_pol"]</code>, then the construction syntax would be

<code class="hang">[k11,<wbr>k21,<wbr>k31,<wbr>k22,<wbr>k32,<wbr>k33] = <wbr>toTensor(<wbr>layer,<wbr>k⊥,<wbr>k∥,<wbr>θ_az,<wbr>θ_pol,<wbr>transform)</code>

where `transform` is an optional argument.

## Description
<a id="d1"></a>
`[`[`k11,k21,k31,k22,k32,k33`](#output-arguments)`] = toTensor(`[`layer`](#layer-argument)`,`[`<layer.inputStr>`](#inputStr-arguments)`)` converts user-input thermal conductivity and orientation variables to tensor representation.
<hr>
<a id="d2"></a>
`toTensor(___, `[`transform`](#transform-argument)`)` applies the function specified by `transform` to strictly-positive thermal conductivity variables (`k`, `k⊥`, `k∥`, `kp1`, `kp2`, `kp3`, `k11`, `k22`, `k33`) provided by the user prior to converting inputs to tensor representation.

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
    {% include_relative _includes/inputStr-details.html key="k" types="\(N_T \times 1\) real vector | \(N_T \times N_\mathrm{pump}\) real matrix" %}
</details>

<details class="custom-details" id="k_perp-argument">
    {% include_relative _includes/inputStr-details.html key="k_perp" types="\(N_T \times 1\) real vector | \(N_T \times N_\mathrm{pump}\) real matrix" %}
</details>

<details class="custom-details" id="k_par-output-argument">
    {% include_relative _includes/inputStr-details.html key="k_par" types="\(N_T \times 1\) real vector | \(N_T \times N_\mathrm{pump}\) real matrix" %}
</details>

<details class="custom-details" id="kpi-output-argument">
    {% include_relative _includes/inputStr-details.html key="kpi" types="\(N_T \times 1\) real vector | \(N_T \times N_\mathrm{pump}\) real matrix" %}
</details>

<details class="custom-details" id="kij-output-argument">
    {% include_relative _includes/inputStr-details.html key="kij" types="\(N_T \times 1\) real vector | \(N_T \times N_\mathrm{pump}\) real matrix" %}
</details>

### Orientation Arguments:

<details class="custom-details" id="az-output-argument">
    {% include_relative _includes/inputStr-details.html key="az" types="\(1 \times N_\mathrm{pump}\) real vector" %}
</details>

<details class="custom-details" id="pol-output-argument">
    {% include_relative _includes/inputStr-details.html key="pol" types="\(1 \times N_\mathrm{pump}\) real vector" %}
</details>

<details class="custom-details" id="vi-output-argument">
    {% include_relative _includes/inputStr-details.html key="vi" types="\(1 \times N_\mathrm{pump}\) real vector" %}
</details>

<details class="custom-details" id="eul-output-argument">
    {% include_relative _includes/inputStr-details.html key="eul" types="\(1 \times N_\mathrm{pump}\) real vector" %}
</details>

<details class="custom-details" id="qi-output-argument">
    {% include_relative _includes/inputStr-details.html key="qi" types="\(1 \times N_\mathrm{pump}\) real vector" %}
</details>

<details class="custom-details" id="Rij-output-argument">
    {% include_relative _includes/inputStr-details.html key="Rij" types="\(1 \times N_\mathrm{pump}\) real vector" %}
</details>

## Output Arguments
<details class="custom-details" id="kij-output-argument">
    {% include_relative _includes/inputStr-details.html key="kij" types="\(N_T \times 1\) real vector | \(N_T \times N_\mathrm{pump}\) real matrix" %}
</details>

## Examples

## See Also
