---
layout: docs
title: Isotropy Enumeration Documentation
permalink: /Documentation/IsotropyEnum
---

# IsotropyEnum

Supported thermal conductivity isotropy types

## Description

`IsotropyEnum` is an enumeration class that defines the supported representations of thermal conductivity.

## Creation

{% include_relative enum-creation.html enumname="IsotropyEnum" varname="isotropy" arrayname="isotropies" %}

## Enumeration Members

<table>
  <tr>
    <td>
      <code>isotropic</code>
    </td>
    <td>
      For scalar thermal conductivity <code>k</code>
    </td>
  </tr>
  <tr>
    <td>
      <code>uniaxial</code>
    </td>
    <td>
      For 2 principal thermal conductivities, transverse (<code>k⊥</code>) and axial (<code>k∥</code>)
    </td>
  </tr>
    <tr>
    <td>
      <code>principal</code>
    </td>
    <td>
      For 3 principal thermal conductivities sorted in descending order, <code>kp1 > kp2 > kp3</code>
    </td>
  </tr>
    <tr>
    <td>
      <code>tensor</code>
    </td>
    <td>
      For 6-element thermal conductivity tensor <code>k11</code>, <code>k21</code>, <code>k31</code>, <code>k22</code>, <code>k32</code>, <code>k33</code>
    </td>
  </tr>
</table>

## See Also
### MLTI Companion Classes and Methods
[`OrientEnum`](/MLTI/Documentation/OrientEnum) | [`Layer`](/MLTI/Documentation/Layer)

### MATLAB Topics
[Enumerations](https://www.mathworks.com/help/matlab/enumeration-classes.html)<br>
[Refer to Enumerations](https://www.mathworks.com/help/matlab/matlab_oop/how-to-refer-to-enumerations.html)<br>
[Enumerations for Property Values](https://www.mathworks.com/help/matlab/matlab_oop/restrict-property-values-to-enumerations.html)






