---
layout: docs
title: Layer Class Documentation
permalink: /Documentation/Layer
---

# Layer

Characterizes the thermal conductivity of a material layer.

## Description

The `Layer` class defines the thermal conductivity of a material layer—whether isotropic, uniaxially anisotropic, or fully anisotropic—and specifies how conductivity is expressed in user inputs. It also handles conversion of user inputs into the tensor representation, which is required by the internal [`ForwardModel`](MLTI/Documentation/ForwardModel) solver.

**Supported Representations:**
<ul>
  <li>
    Isotropic conductivity: <code>k</code>
  </li>
  <li>
    Transverse and axial conductivities (<code>k⊥</code>, <code>k∥</code>) with
    <ul>
      <li>
        Azimuthal and polar axis direction angles: <code>θ_az</code>, <code>θ_pol</code>
      </li>
      <li>
        Unit vector axis direction: <code>v1</code>, <code>v2</code>, <code>v3</code>
      </li>
    </ul>
  </li>
  <li>
    Principal conductivities (<code>kp1</code>, <code>kp2</code>, <code>kp3</code>) with
    <ul>
      <li>
        Euler orientation angles: <code>θa1</code>, <code>θb2</code>, <code>θc3</code>
      </li>
      <li>
        Unit quaternion orientation: <code>q1</code>, <code>q2</code>, <code>q3</code>, <code>q4</code>
      </li>
      <li>
        Vectorized rotation matrix orientation: <code>R11</code>, <code>R21</code>, <code>R31</code>, <code>R12</code>, <code>R22</code>, <code>R32</code>, <code>R13</code>, <code>R23</code>, <code>R33</code>
      </li>
    </ul>
  </li>
  <li>
    6-element tensor conductivity: <code>k11</code>, <code>k21</code>, <code>k31</code>, <code>k22</code>, <code>k32</code>, <code>k33</code>
  </li>
</ul>

## Creation

### Syntax

[`layer = Layer()`](#d1)<br>
[`layer = Layer(isotropy)`](#d2)<br>
[`layer = Layer(isotropy,orient)`](#d3)<br>
[`layer = Layer(isotropy,orient,euler_seq)`](#d4)<br>

### Description
<a id="d1"></a>
`layer = Layer()` creates a `Layer` object using the default tensor representation of thermal conductivity.
<hr>
<a id="d2"></a>
`layer = Layer(`[`isotropy`](#isotropy-argument)`)` creates a `Layer` object with a user-specified isotropy type. Valid only for `"isotropic"` and `"tensor"` conductivity representations, since `orient` must also be specified for `"uniaxial"` and `"principal"` cases.
<hr>
<a id="d3"></a>
`layer = Layer(`[`isotropy`](#isotropy-argument)`,`[`orient`](#orient-argument)`)` creates a `Layer` object with a user-specified isotropy type and orientation. Valid only for `"uniaxial"` and `"principal"` representations, since `orient` is not required for `"isotropic"` or `"tensor"`. If Euler orientation angles are used, `euler_seq` must also be provided (see next).
<hr>
<a id="d4"></a>
`layer = Layer(`[`isotropy`](#isotropy-argument)`,`[`orient`](#orient-argument)`,`[`euler_seq`](#euler-seq-argument)`)` creates a `Layer` object with a user-specified isotropy type, orientation, and Euler angle sequence. Valid only when `orient` is `"euler"`, since `euler_seq` is not required for other orientations.

### Input Arguments
<details class="custom-details" id="isotropy-argument">
    <summary>
        <span class="summary-text">
            <b><code>isotropy</code> - Isotropy type</b>
            <span class="subline">
              <code>"tensor"</code> (default) | <code>"isotropic"</code> | <code>"uniaxial"</code> | <code>"principal"</code> | <a href="{{ '/Documentation/IsotropyEnum' | relative_url }}"><code>IsotropyEnum</code></a> object
            </span>
        </span>
    </summary>
    <div>
        <p>
            Isotropy type specifies the isotropy level of the layer.
        </p>
        <ul>
            <li>
              <code>"isotropic"</code>: {{ site.data.EnumDescriptions.IsotropyEnum.isotropic }}
            </li>
                <code>"uniaxial"</code>: {{ site.data.EnumDescriptions.IsotropyEnum.uniaxial }}
            </li>
            <li>
              <code>"principal"</code>: {{ site.data.EnumDescriptions.IsotropyEnum.principal }}
            </li>
            <li>
              <code>"tensor"</code>: {{ site.data.EnumDescriptions.IsotropyEnum.tensor }}
            </li>
        </ul>
        <p>
            <code>char</code> and <code>string</code> inputs are *case-insensitive* and may be specified as a unique leading substring of any one of the above listed options.
        </p>
        <p>
            <b>Data Types:</b> <code>char</code> | <code>string</code> | <a href="{{ '/Documentation/IsotropyEnum' | relative_url }}"><code>IsotropyEnum</code></a>
        </p>
    </div>
</details>

<details class="custom-details" id="orient-argument">
    <summary>
        <span class="summary-text">
            <b><code>orient</code> - Orientation type</b>
            <span class="subline">
                <code>"na"</code> (default) | <code>"azpol"</code> | <code>"uvect"</code> | <code>"euler"</code> | <code>"uquat"</code> | <code>"rotmat"</code> | <a href="{{ '/Documentation/OrientEnum' | relative_url }}"><code>OrientEnum</code></a> object
            </span>
        </span>
    </summary>
    <div>
        <p>
            Orientation type specifies the symmetric axis direction (<code>isotropy="uniaxial"</code>) or the principal axes orientation (<code>isotropy="principal"</code>).
            Required only when <code>isotropy</code> equals either <code>"uniaxial"</code> or <code>"principal"</code>.
        </p>
        <ul>
          <li>
            <code>"na"</code>: {{ site.data.EnumDescriptions.OrientEnum.na }}
          </li>
            <li>
              <code>"azpol"</code>: {{ site.data.EnumDescriptions.OrientEnum.azpol }}. Valid only when <code>film_isotropy = "uniaxial"</code>.
            </li>
            <li>
              <code>"uvect"</code>: {{ site.data.EnumDescriptions.OrientEnum.uvect }}. Valid only when <code>film_isotropy = "uniaxial"</code>.
            </li>
            <li>
              <code>"euler"</code>: {{ site.data.EnumDescriptions.OrientEnum.euler }}
            </li>
            <li>
              <code>"uquat"</code>: {{ site.data.EnumDescriptions.OrientEnum.uquat }}
            </li>
            <li>
              <code>"rotmat"</code>: {{ site.data.EnumDescriptions.OrientEnum.rotmat }}
            </li>
        </ul>
        <p>
            <code>char</code> and <code>string</code> inputs are *case-insensitive* and may be specified as a unique leading substring of any one of the above listed options.
        </p>
        <p>
            <b>Data Types:</b> <code>char</code> | <code>string</code> | <a href="{{ '/Documentation/OrientEnum' | relative_url }}"><code>OrientEnum</code></a>
        </p>
    </div>
</details>

<details class="custom-details" id="euler-seq-argument">
    <summary>
        <span class="summary-text">
            <b><code>euler_seq</code> - Euler angle sequence</b>
            <span class="subline">
                <code>"na"</code> (default) | <code>"XYX"</code> | <code>"XYZ"</code> | <code>"XZX"</code> | <code>"XZY"</code> | <code>"YXY"</code> | <code>"YXZ"</code> | <code>"YZX"</code> | <code>"YZY"</code> | <code>"ZXY"</code> | <code>"ZXZ"</code> | <code>"ZYX"</code> | <code>"ZYZ"</code> | <a href="{{ '/Documentation/SeqEnum' | relative_url }}"><code>SeqEnum</code></a> object
            </span>
        </span>
    </summary>
    <div>
        <p>
            Euler angle sequence specified as three axes.
            I.e., computes the rotation matrix as \(\mathbf{R} = \mathbf{R}_a\left(\theta_1\right) \cdot \mathbf{R}_b\left(\theta_2\right) \cdot \mathbf{R}_c\left(\theta_3\right)\), where \(a, b, c \in \left\{x, y, z\right\}\) are the 1st, 2nd, and 3rd characters of the input character array, and:
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
            Required only when <code>orient</code> equals <code>"euler"</code>.
        </p>
        <p>
            <code>char</code> and <code>string</code> inputs are *case-insensitive* and may be specified as a unique leading substring of any one of the above listed options.
        </p>
        <p>
            <b>Data Types:</b> <code>char</code> | <code>string</code> | <a href="{{ '/Documentation/SeqEnum' | relative_url }}"><code>SeqEnum</code></a>
        </p>
    </div>
</details>

## Properties
`Layer` properties include validated constructor input arguments as well as the following:

<details class="custom-details" id="inputStr-property">
    <summary>
        <span class="summary-text">
            <b><code>inputStr</code> - <code>toTensor</code> input variable names</b>
            <span class="subline">
                Read only: string row vector
            </span>
        </span>
    </summary>
    <div>
      <p>
        Since the number of inputs to the <code>toTensor</code> function depends on the arguments specified when the object is created, <code>inputStr</code> provides the names of the <code>toTensor</code> input variables as a string row vector.
      </p>
        <b>Data Type:</b> <code>string</code>
      </p>
      <p>
        <b>Example:</b> if <code>isotropy == "uniaxial"</code> and <code>orient == "azpol"</code>, then <code>inputStr = ["k⊥", "k∥", "θ_az", "θ_pol"]</code>, and the user can call <code>layer.toTensor(<wbr>k⊥,<wbr>k∥,<wbr>θ_az,<wbr>θ_pol)</code> to convert to tensor conductivity representation.
      </p>
    </div>
</details>

## Object Functions
<table>
  <tr>
    <td>
      <a href="{{ '/Documentation/Layer/toTensor' | relative_url }}"><code>toTensor</code></a>
    </td>
    <td>
      Converts user inputs to tensor representation
    </td>
  </tr>
</table>

## Examples

<details class="custom-details" id="inputStr-property">
  <summary>
    <span class="summary-text">
      <b>Constructing a Uniaxially Symmetric Thermal Conductivity Tensor</b>
    </span>
  </summary>
  <div>
    {% include md-include.html file="examples/UniaxialLayerCreation.md" %}
  </div>
</details>

## See Also
