---
layout: docs
title: Seq Enumeration Documentation
permalink: /Documentation/SeqEnum
---

# SeqEnum

Supported Euler sequences

## Description

`SeqEnum` is an enumeration class that defines supported intrinsic Euler rotation sequences, expressed as three consecutive axes (x, y, or z) in which no two consecutive axes are identical.

## Creation

{% include_relative _includes/enum-creation.html enumname="SeqEnum" varname="seq" arrayname="seqs" %}

## Enumeration Members

<table>
  <tr>
    <td>
      <code>na</code>
    </td>
    <td>
      No sequence specified
    </td>
  </tr>
  {% include_relative _includes/seq-tr.html seq="xyx" %}
  {% include_relative _includes/seq-tr.html seq="xyz" %}
  {% include_relative _includes/seq-tr.html seq="xzx" %}
  {% include_relative _includes/seq-tr.html seq="xzy" %}
  {% include_relative _includes/seq-tr.html seq="yxy" %}
  {% include_relative _includes/seq-tr.html seq="yxz" %}
  {% include_relative _includes/seq-tr.html seq="yzx" %}
  {% include_relative _includes/seq-tr.html seq="yzy" %}
  {% include_relative _includes/seq-tr.html seq="zxy" %}
  {% include_relative _includes/seq-tr.html seq="zxz" %}
  {% include_relative _includes/seq-tr.html seq="zyx" %}
  {% include_relative _includes/seq-tr.html seq="zyz" %}
</table>

## See Also
### MLTI Companion Classes and Methods
[`IsotropyEnum`](/MLTI/Documentation/IsotropyEnum) | [`OrientEnum`](/MLTI/Documentation/OrientEnum) | [`Layer`](/MLTI/Documentation/Layer)

### MATLAB Built-in Methods
[`eul2rotm`](https://www.mathworks.com/help/robotics/ref/eul2rotm.html) | [`quat2rotm`](https://www.mathworks.com/help/robotics/ref/quat2rotm.html)

### MATLAB Topics
[Enumerations](https://www.mathworks.com/help/matlab/enumeration-classes.html)<br>
[Refer to Enumerations](https://www.mathworks.com/help/matlab/matlab_oop/how-to-refer-to-enumerations.html)<br>
[Enumerations for Property Values](https://www.mathworks.com/help/matlab/matlab_oop/restrict-property-values-to-enumerations.html)







