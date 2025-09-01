---
layout: docs
title: toTensor Function Documentation
permalink: /Documentation/Layer/toTensor
---

# toTensor

## Description

## Creation

### Syntax
<a href="#d1">
<code class="hang">[k11,<wbr>k21,<wbr>k31,<wbr>k22,<wbr>k32,<wbr>k33] = <wbr>toTensor(<wbr>layer,<wbr>&lt;layer.inputStr&gt;)</code>
</a><br>
<a href="#d2">
<code class="hang">[___] = <wbr>toTensor(___,<wbr>transform)</code>
</a><br>

Where `<layer.inputStr>` specifies a variable number of inputs, fixed when the `layer` object is constructed.  

**Example:**

If <code>layer.inputStr ==<wbr> ["k⊥",<wbr>"k∥",<wbr>"θ_az",<wbr>"θ_pol"]</code>, then the construction syntax would be

<code class="hang">[k11,<wbr>k21,<wbr>k31,<wbr>k22,<wbr>k32,<wbr>k33] = <wbr>toTensor(<wbr>layer,<wbr>k⊥,<wbr>k∥,<wbr>θ_az,<wbr>θ_pol,<wbr>transform)</code>

where `transform` is an optional argument.

### Description
<a id="d1"></a>
`[`[`k11`](#k11-output)`,`[`k21`](#k21-output)`,`[`k31`](#k31-output)`,`[`k22`](#k22-output)`,`[`k32`](#k32-output)`,`[`k33`](#k33-output)`] = toTensor(`[`layer`](#layer-argument)`,`[`<layer.inputStr>`](#inputStr-arguments)`)` converts user input thermal conductivity and orientation variables to tensor representation.
<hr>
<a id="d2"></a>
`[___] = toTensor(___, `[`transform`](#transform-argument)`)` applies the function specified by `transform` to strictly-positive thermal conductivity variables (`k`,`k⊥`,`k∥`,`kp1`,`kp2`,`kp3`,`k11`,`k22`,`k33`) provided by the user, and then converts these transformed inputs along with any orientation variables into the full tensor representation.

### Input Arguments

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

<h3 id="inputStr-arguments"><code>inputStr</code> Arguments</h3>
<table>
  <tr>
    <td>
      {{ site.data.nomenclature.k.symbol }}
    </td>
    <td>
      {{ site.data.nomenclature.k.description }}
    </td>
  </tr>
  <tr>
    <td>
      {{ site.data.nomenclature.k_perp.symbol }}
    </td>
    <td>
      {{ site.data.nomenclature.k_perp.description }}
    </td>
  </tr>
  <tr>
    <td>
      {{ site.data.nomenclature.k_par.symbol }}
    </td>
    <td>
      {{ site.data.nomenclature.k_par.description }}
    </td>
  </tr>
  <tr>
    <td>
      {{ site.data.nomenclature.kpi.symbol }}
    </td>
    <td>
      {{ site.data.nomenclature.kpi.description }}
    </td>
  </tr>
  <tr>
    <td>
      {{ site.data.nomenclature.kij.symbol }}
    </td>
    <td>
      {{ site.data.nomenclature.kij.description }}
    </td>
  </tr>
</table>

### Output Arguments

## Properties

## Object Functions

## Examples

## See Also
