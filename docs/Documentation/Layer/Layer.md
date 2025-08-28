---
layout: docs
title: Layer Class Documentation
permalink: /Documentation/Layer
---

# Layer

Characterizes a material layer and converts user input into canonical thermal properties.

## Syntax

## Description

## Creation

### Syntax
<hr>

[`layer = Layer()`](#d1)<br>
[`layer = Layer(isotropy)`](#d2)<br>
[`layer = Layer(isotropy,orient)`](#d3)<br>
[`layer = Layer(isotropy,orient,euler_seq)`](#d4)<br>
[`layer = Layer(___,Name,Value)`](#d5)<br>

### Description
<a id="d1"></a><hr>
`layer = Layer()` creates a `Layer` object using the default tensor representation of thermal conductivity.
<a id="d2"></a><hr>
`layer = Layer(`[`isotropy`](#i1)`)` creates a `Layer` object with a user-specified isotropy type. Valid only for `isotropic` and `tensor` representations, since `orient` must also be specified for `uniaxial` and `principal` cases.
<a id="d3"></a><hr>
`layer = Layer(`[`isotropy`](#i1)`,`[`orient`](#i2)`)` creates a `Layer` object with a user-specified isotropy type and orientation. Valid only for `uniaxial` and `principal` representations, since `orient` is not required for `isotropic` or `tensor`.
<a id="d4"></a><hr>
`layer = Layer(`[`isotropy`](#i1)`,`[`orient`](#i2)`,`[`euler_seq`](#i3)`)` creates a `Layer` object with a user-specified isotropy type, orientation, and Euler sequence. Valid only when `orient` is `euler`, since `euler_seq` is not required for other orientations.
<a id="d5"></a><hr>
`layer = Layer(___,`[`Name,Value`](#name-value-arguments)`)` creates a `Layer` object using one or more name-value arguments. Specify the name-value arguments after all the arguments in any of the previous syntaxes.
<hr>

### Input Arguments
<details class="custom-details" id="i1">
    <summary>
        <span class="summary-text">
            <b><code>isotropy</code> - Isotropy type</b>
            <span class="subline">
              <code>"tensor"</code> (default) | <code>"iso"</code> | <code>"simple"</code> | <code>"complex"</code></span>
        </span>
    </summary>
    <div>
        <p>
            Isotropy type specifies the isotropy level of the layer.
        </p>
        <ul>
            <li><code>"iso"</code>: For scalar thermal conductivity <code>kf</code></li>
            <li><code>"uniaxial"</code>: For 2 principal thermal conductivities along a specified axis <code>kf∥</code> and perpendicular to that axis <code>kf⊥</code></li>
            <li><code>"principal"</code>: For 3 principal thermal conductivities sorted in descending order <code>kfp1</code> < <code>kfp2</code> < <code>kfp3</code></li>
            <li><code>"tensor"</code>: For 6 element thermal conductivity tensor <code>K11</code>, <code>K21</code>, <code>K31</code>, <code>K22</code>, <code>K32</code>, <code>K33</code></li>
        </ul>
        <p>
            <code>char</code> and <code>string</code> inputs are case-insensitive and may be specified as a unique leading substring of any one of the above listed options.
        </p>
        <p>
            <b>Data Types:</b> <code>char</code> | <code>string</code> | <a href="{{ '/Documentation/IsotropyEnum' | relative_url }}"><code>IsotropyEnum</code></a>
        </p>
    </div>
</details>
<a id="i2"></a>
<a id="i3"></a>

#### Name-Value Arguments

### Examples


## Properties

## Object Functions

## Examples

## See Also