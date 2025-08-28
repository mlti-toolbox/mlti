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

[`layer = Layer()`](#d1)<br>
[`layer = Layer(isotropy)`](#d2)<br>
[`layer = Layer(isotropy,orient)`](#d3)<br>
[`layer = Layer(isotropy,orient,euler_seq)`](#d4)<br>
[`layer = Layer(___,Name,Value)`](#d5)<br>

### Description

<a id="d1"></a>

`layer = Layer()` creates a `Layer` object using the default tensor representation of thermal conductivity.

<a id="d2"></a>

<hr>

`layer = Layer(`[`isotropy`](#isotropy-argument)`)` creates a `Layer` object with a user-specified isotropy type. Valid only for `isotropic` and `tensor` representations, since `orient` must also be specified for `uniaxial` and `principal` cases.

<a id="d3"></a>

<hr>

`layer = Layer(`[`isotropy`](#isotropy-argument)`,`[`orient`](#orient-argument)`)` creates a `Layer` object with a user-specified isotropy type and orientation. Valid only for `uniaxial` and `principal` representations, since `orient` is not required for `isotropic` or `tensor`.

<a id="d4"></a>

<hr>

`layer = Layer(`[`isotropy`](#isotropy-argument)`,`[`orient`](#orient-argument)`,`[`euler_seq`](#euler-seq-argument)`)` creates a `Layer` object with a user-specified isotropy type, orientation, and Euler sequence. Valid only when `orient` is `euler`, since `euler_seq` is not required for other orientations.

<a id="d5"></a>

<hr>

`layer = Layer(___,`[`Name,Value`](#name-value-arguments)`)` creates a `Layer` object using one or more name-value arguments. Specify the name-value arguments after all the arguments in any of the previous syntaxes.

### Input Arguments
<details class="custom-details" id="isotropy-argument">
    <summary>
        <span class="summary-text">
            <b><code>isotropy</code> - Isotropy type</b>
            <span class="subline">
              <code>"tensor"</code> (default) | <code>"iso"</code> | <code>"uniaxial"</code> | <code>"principal"</code></span>
        </span>
    </summary>
    <div>
        <p>
            Isotropy type specifies the isotropy level of the layer.
        </p>
        <ul>
            <li><code>"iso"</code>: For scalar thermal conductivity <code>k</code></li>
            <li><code>"uniaxial"</code>: For 2 principal thermal conductivities along a specified axis <code>k∥</code> and perpendicular to that axis <code>k⊥</code></li>
            <li><code>"principal"</code>: For 3 principal thermal conductivities sorted in descending order <code>kp1 > kp2 > kp3</code></li>
            <li><code>"tensor"</code>: For 6 element thermal conductivity tensor <code>K11</code>, <code>K21</code>, <code>K31</code>, <code>K22</code>, <code>K32</code>, <code>K33</code></li>
        </ul>
        <p>
            <code>char</code> and <code>string</code> inputs are case-insensitive and may be specified as a unique leading substring of any one of the above listed options.
        </p>
        <p>
            <b>Data Types:</b> <code>char</code> | <code>string</code> | <a href="{{ '/Documentation/OrientEnum' | relative_url }}"><code>OrientEnum</code></a>
        </p>
    </div>
</details>

<details class="custom-details" id="orient-argument">
    <summary>
        <span class="summary-text">
            <b><code>orient</code> - Orientation type</b>
            <span class="subline">
                <code>"azpol"</code> | <code>"uvect"</code> | <code>"euler"</code> | <code>"uquat"</code> | <code>"rotmat"</code>
            </span>
        </span>
    </summary>
    <div>
        <p>
            Orientation type specifies how the principal axes orientations of the layer are represented.
            Required when <code>isotropy</code> equals either <code>"uniaxial"</code> or <code>"principal"</code>.
        </p>
        <ul>
            <li><code>"azpol"</code>: For representing the <code>k∥</code> axis as azimuthal <code>θ_az</code> and polar <code>θ_pol</code> angles. Use only when <code>film_isotropy = "uniaxial"</code>.</li>
            <li><code>"uvect"</code>: For representing the <code>k∥</code> axis as a unit vector <code>v1</code>, <code>v2</code>, <code>v3</code>. Use only when <code>film_isotropy = "uniaxial"</code>.</li>
            <li><code>"euler"</code>: For representing the orientation of the principal axes as Euler angles <code>θA1</code>, <code>θB2</code>, <code>θC3</code>, with <code>A</code>, <code>B</code>, <code>C</code> \(\in\) {<code>'X'</code>, <code>'Y'</code>, <code>'Z'</code>}</li>
            <li><code>"uquat"</code>: For representing the orientation of the principal axes as a unit quaternion <code>q1</code>, <code>q2</code>, <code>q3</code>, <code>q4</code>.</li>
            <li><code>"rotmat"</code>: For representing the orientation of the principal axes as a rotation matrix <code>R11</code>, <code>R21</code>, <code>R31</code>, <code>R12</code>, <code>R22</code>, <code>R32</code>, <code>R13</code>, <code>R23</code>, <code>R33</code>.</li>
        </ul>
        <p>
            <code>char</code> and <code>string</code> inputs are case-insensitive and may be specified as a unique leading substring of any one of the above listed options.
        </p>
        <p>
            <b>Data Types:</b> <code>char</code> | <code>string</code> | <a href="{{ '/Documentation/IsotropyEnum' | relative_url }}"><code>IsotropyEnum</code></a>
        </p>
    </div>
</details>

<details class="custom-details" id="euler-seq-argument">
    <summary>
        <span class="summary-text">
            <b><code>euler_seq</code> - Euler angle sequence</b>
            <span class="subline">
                <code>'ZYZ'</code> (default) | <code>'ZXZ'</code> | <code>'ZYX'</code> | <code>'ZXY'</code> | <code>'YXY'</code> | <code>'YZY'</code> | <code>'YXZ'</code> | <code>'YZX'</code> | <code>'XYX'</code> | <code>'XZX'</code> | <code>'XYZ'</code> | <code>'XZY'</code>
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
            <code>char</code> and <code>string</code> inputs are case-insensitive and may be specified as a unique leading substring of any one of the above listed options.
        </p>
        <p>
            <b>Data Types:</b> <code>char</code> | <code>string</code> | <a href="{{ '/Documentation/SeqEnum' | relative_url }}"><code>SeqEnum</code></a>
        </p>
    </div>
</details>

### Name-Value Arguments

### Examples


## Properties

## Object Functions

## Examples

## See Also
