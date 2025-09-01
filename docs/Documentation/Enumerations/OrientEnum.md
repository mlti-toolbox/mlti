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
      {{ site.data.EnumDescriptions.OrientEnum.na }}
    </td>
  </tr>
  <tr>
    <td>
      <code>azpol</code>
    </td>
    <td>
      {{ site.data.EnumDescriptions.OrientEnum.azpol }}
    </td>
  </tr>
    <tr>
    <td>
      <code>uvect</code>
    </td>
    <td>
      {{ site.data.EnumDescriptions.OrientEnum.uvect }}
    </td>
  </tr>
    <tr>
    <td>
      <code>euler</code>
    </td>
    <td>
      {{ site.data.EnumDescriptions.OrientEnum.euler }}
    </td>
  </tr>
      <tr>
    <td>
      <code>uquat</code>
    </td>
    <td>
      {{ site.data.EnumDescriptions.OrientEnum.uquat }}
    </td>
  </tr>
      <tr>
    <td>
      <code>rotmat</code>
    </td>
    <td>
      {{ site.data.EnumDescriptions.OrientEnum.rotmat }}
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











