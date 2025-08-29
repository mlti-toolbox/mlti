---
layout: docs
title: Orient Enumeration Documentation
permalink: /Documentation/OrientEnum
---

# OrientEnum

Supported direction/orientation types

## Description

`IsotropyEnum` is an enumeration class that defines the supported axial direction/orientation of principal thermal conductivities.

## Creation

### Direct Construction
<code class="hang">orient = OrientEnum.member</code>

### Conversion from Character or String Arrays
<code class="hang">orient = OrientEnum('memberName')</code><br>
<code class="hang">orient = OrientEnum("memberName")</code>

### Creating an `OrientEnum` Enumeration Array
<code class="hang">orient = [OrientEnum.member1,<wbr>IsotropyEnum.member2,...]</code><br>
<code class="hang">orient = OrientEnum({'memberName1',<wbr>'memberName2',...})</code><br>
<code class="hang">orient = OrientEnum(["memberName1",<wbr>"memberName2",...])</code>

See "[Refer to Enumerations](https://www.mathworks.com/help/matlab/matlab_oop/how-to-refer-to-enumerations.html)" for more details.

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
      For representing the orientation of the principal axes as Euler angles <code>θA1</code>, <code>θB2</code>, <code>θC3</code>, with <code>A</code>, <code>B</code>, <code>C</code> \(\in\) {<code>'X'</code>, <code>'Y'</code>, <code>'Z'</code>}
    </td>
  </tr>
      <tr>
    <td>
      <code>uquat</code>
    </td>
    <td>
      For representing the orientation of the principal axes as a unit quaternion <code>q1</code>, <code>q2</code>, <code>q3</code>, <code>q4</code>
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
[`IsotropyEnum`](/MLTI/Documentation/OrientEnum) | [`SeqEnum`](/MLTI/Documentation/OrientEnum) | [`Layer`](/MLTI/Documentation/Layer)

### MATLAB Built-in Methods
[`eul2rotm`](https://www.mathworks.com/help/robotics/ref/eul2rotm.html) | [`quat2rotm`](https://www.mathworks.com/help/robotics/ref/quat2rotm.html)

### MATLAB Topics
[Enumerations](https://www.mathworks.com/help/matlab/enumeration-classes.html)<br>
[Refer to Enumerations](https://www.mathworks.com/help/matlab/matlab_oop/how-to-refer-to-enumerations.html)<br>
[Enumerations for Property Values](https://www.mathworks.com/help/matlab/matlab_oop/restrict-property-values-to-enumerations.html)





