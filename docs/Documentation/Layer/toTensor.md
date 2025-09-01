---
layout: docs
title: toTensor Function Documentation
permalink: /Documentation/Layer/toTensor
---

# toTensor

Converts user inputs to tensor representation.

## Syntax
When `layer.isotropy` is `isotropic`:<br>
<a href="#d1"><code class="hang">[k11,<wbr>k21,<wbr>k31,<wbr>k22,<wbr>k32,<wbr>k33] = <wbr>toTensor(<wbr>layer,<wbr>k)</code></a><br>
When `layer.isotropy` is `uniaxial` & `layer.orient` is `azpol`:<br>
<a href="#d2"><code class="hang">[k11,<wbr>k21,<wbr>k31,<wbr>k22,<wbr>k32,<wbr>k33] = <wbr>toTensor(<wbr>layer,<wbr>k⊥,<wbr>k∥,<wbr>θ_az,<wbr>θ_pol)</code></a><br>
When `layer.isotropy` is `uniaxial` & `layer.orient` is `uvect`:<br>
<a href="#d3"><code class="hang">[k11,<wbr>k21,<wbr>k31,<wbr>k22,<wbr>k32,<wbr>k33] = <wbr>toTensor(<wbr>layer,<wbr>k⊥,<wbr>k∥,<wbr>v1,<wbr>v2,<wbr>v3)</code></a><br>
When `layer.isotropy` is `principal` & `layer.orient` is `euler`:<br>
<a href="#d4"><code class="hang">[k11,<wbr>k21,<wbr>k31,<wbr>k22,<wbr>k32,<wbr>k33] = <wbr>toTensor(<wbr>layer,<wbr>kp1,<wbr>kp2,<wbr>kp3,<wbr>θa1,<wbr>θb2,<wbr>θc3)</code></a><br>
When `layer.isotropy` is `principal` & `layer.orient` is `uquat`:<br>
<a href="#d5"><code class="hang">[k11,<wbr>k21,<wbr>k31,<wbr>k22,<wbr>k32,<wbr>k33] = <wbr>toTensor(<wbr>layer,<wbr>kp1,<wbr>kp2,<wbr>kp3,<wbr>q1,<wbr>q2,<wbr>q3,<wbr>q4)</code></a><br>
When `layer.isotropy` is `principal` & `layer.orient` is `rotmat`:<br>
<a href="#d6"><code class="hang">[k11,<wbr>k21,<wbr>k31,<wbr>k22,<wbr>k32,<wbr>k33] = <wbr>toTensor(<wbr>layer,<wbr>kp1,<wbr>kp2,<wbr>kp3,<wbr>R11,<wbr>R21,<wbr>R31,<wbr>R12,<wbr>R22,<wbr>R32,<wbr>R13,<wbr>R23,<wbr>R33)</code></a><br>
When `layer.isotropy` is `tensor`:<br>
<a href="#d7"><code class="hang">[k11,<wbr>k21,<wbr>k31,<wbr>k22,<wbr>k32,<wbr>k33] = <wbr>toTensor(<wbr>layer,<wbr>k11,<wbr>k21,<wbr>k31,<wbr>k22,<wbr>k32,<wbr>k33)</code></a><br>
When a pre-conversion transformation is required:<br>
<a href="#d8"><code class="hang">[k11,<wbr>k21,<wbr>k31,<wbr>k22,<wbr>k32,<wbr>k33] = <wbr>toTensor(___,<wbr>transform)</code></a><br>

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
<table>
  <tr>
    <td>
      {{ site.data.nomenclature.k.codeSymbol | safe }}
    </td>
    <td>
      {{ site.data.nomenclature.k.description | safe }}
    </td>
  </tr>
  <tr>
    <td>
      {{ site.data.nomenclature.k_perp.codeSymbol | safe }}
    </td>
    <td>
      {{ site.data.nomenclature.k_perp.description | safe }}
    </td>
  </tr>
  <tr>
    <td>
      {{ site.data.nomenclature.k_par.codeSymbol | safe }}
    </td>
    <td>
      {{ site.data.nomenclature.k_par.description | safe }}
    </td>
  </tr>
  <tr>
    <td>
      {{ site.data.nomenclature.kpi.codeSymbol | safe }}
    </td>
    <td>
      {{ site.data.nomenclature.kpi.description | safe }}
    </td>
  </tr>
  <tr>
    <td>
      {{ site.data.nomenclature.kij.codeSymbol | safe }}
    </td>
    <td>
      {{ site.data.nomenclature.kij.description | safe }}
    </td>
  </tr>
  <tr>
    <td>
      {{ site.data.nomenclature.az.codeSymbol | safe }}
    </td>
    <td>
      {{ site.data.nomenclature.az.description | safe }}
    </td>
  </tr>
  <tr>
    <td>
      {{ site.data.nomenclature.pol.codeSymbol | safe }}
    </td>
    <td>
      {{ site.data.nomenclature.pol.description | safe }}
    </td>
  </tr>
  <tr>
    <td>
      {{ site.data.nomenclature.eul.codeSymbol | safe }}
    </td>
    <td>
      {{ site.data.nomenclature.eul.description | safe }}
    </td>
  </tr>
  <tr>
    <td>
      {{ site.data.nomenclature.vi.codeSymbol | safe }}
    </td>
    <td>
      {{ site.data.nomenclature.vi.description | safe }}
    </td>
  </tr>
    <tr>
    <td>
      {{ site.data.nomenclature.qi.codeSymbol | safe }}
    </td>
    <td>
      {{ site.data.nomenclature.qi.description | safe }}
    </td>
  </tr>
  <tr>
    <td>
      {{ site.data.nomenclature.Rij.codeSymbol | safe }}
    </td>
    <td>
      {{ site.data.nomenclature.Rij.description | safe }}
    </td>
  </tr>
</table>

## Output Arguments
<details class="custom-details" id="layer-argument">
    <summary>
        <span class="summary-text">
            <b><code>kij</code> - \((i,j)\)-th tensor component</b>a
            <span class="subline">
                \(N_T \times N_\mathrm{pump}\) real matrix
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
