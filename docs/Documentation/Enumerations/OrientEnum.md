---
layout: docs
title: Orient Enumeration Documentation
permalink: /Documentation/OrientEnum
---

# OrientEnum

Supported direction/orientation types

## Description

`OrientEnum` is an enumeration class that defines the supported axial direction/orientation of principal thermal conductivities.

## Creation

{% include_relative _includes/enum-creation.html enumname="OrientEnum" varname="orient" arrayname="orients" %}

## Enumeration Members

<table>
  <tr>
    <td>
      <code>na</code>
    </td>
    <td>
      No orientation specified
    </td>
  </tr>
  <tr>
    <td>
      <code>azpol</code>
    </td>
    <td>
      For representing the symmetric axis direction as azimuthal <code>θ_az</code> and polar <code>θ_pol</code> angles
    </td>
  </tr>
    <tr>
    <td>
      <code>uvect</code>
    </td>
    <td>
      For representing the symmetric axis direction as a unit vector <code>v1</code>, <code>v2</code>, <code>v3</code>
    </td>
  </tr>
    <tr>
    <td>
      <code>euler</code>
    </td>
    <td>
      For representing the orientation of the principal axes as Euler angles <code>θa1</code>, <code>θb2</code>, <code>θc3</code>, with <code>a</code>, <code>b</code>, <code>c</code> \(\in\) {<code>x</code>, <code>y</code>, <code>z</code>}
    </td>
  </tr>
      <tr>
    <td>
      <code>uquat</code>
    </td>
    <td>
      For representing the orientation of the principal axes as a unit quaternion <code>q0</code>, <code>q1</code>, <code>q2</code>, <code>q3</code>
    </td>
  </tr>
      <tr>
    <td>
      <code>rotmat</code>
    </td>
    <td>
      For representing the orientation of the principal axes as a vectorized rotation matrix <code>R11</code>, <code>R21</code>, <code>R31</code>, <code>R12</code>, <code>R22</code>, <code>R32</code>, <code>R13</code>, <code>R23</code>, <code>R33</code>
    </td>
  </tr>
</table>

## See Also
### MLTI Companion Classes and Methods
[`IsotropyEnum`](/MLTI/Documentation/IsotropyEnum) | [`SeqEnum`](/MLTI/Documentation/SeqEnum) | [`Layer`](/MLTI/Documentation/Layer)

### MATLAB Built-in Methods
[`eul2rotm`](https://www.mathworks.com/help/robotics/ref/eul2rotm.html) | [`quat2rotm`](https://www.mathworks.com/help/robotics/ref/quat2rotm.html)

### MATLAB Topics
[Enumerations](https://www.mathworks.com/help/matlab/enumeration-classes.html)<br>
[Refer to Enumerations](https://www.mathworks.com/help/matlab/matlab_oop/how-to-refer-to-enumerations.html)<br>
[Enumerations for Property Values](https://www.mathworks.com/help/matlab/matlab_oop/restrict-property-values-to-enumerations.html)









