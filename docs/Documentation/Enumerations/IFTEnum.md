---
layout: docs
title: IFT Enumeration Documentation
permalink: /Documentation/IFTEnum
---

# IFTEnum

Inverse Fourier transform evaluation methods

## Description

`IFTEnum` is an enumeration class that defines supported methods for evaluating the 2D inverse Fourier transform.

## Creation

{% include_relative enum-creation.html enumname="IFTEnum" varname="method" arrayname="methods" %}

## Enumeration Members

<table>
  <tr>
    <td>
      <code>ifft2</code>
    </td>
    <td>
      Use MATLAB's built-in <a href="https://www.mathworks.com/help/matlab/ref/ifft2.html"><code>ifft2</code></a> method
    </td>
  </tr>
  <tr>
    <td>
      <code>integral2</code>
    </td>
    <td>
      Use MATLAB's built-in <a href="https://www.mathworks.com/help/matlab/ref/integral2.html"><code>integral2</code></a> method
    </td>
  </tr>
</table>

## See Also
### MLTI Companion Classes and Methods
[`IFTSolver`](/MLTI/Documentation/IFTSolver)

### MATLAB Built-in Methods
[`ifft2`](https://www.mathworks.com/help/matlab/ref/ifft2.html) | [`integral2`](https://www.mathworks.com/help/matlab/ref/integral2.html)

### MATLAB Topics
[Enumerations](https://www.mathworks.com/help/matlab/enumeration-classes.html)<br>
[Refer to Enumerations](https://www.mathworks.com/help/matlab/matlab_oop/how-to-refer-to-enumerations.html)<br>
[Enumerations for Property Values](https://www.mathworks.com/help/matlab/matlab_oop/restrict-property-values-to-enumerations.html)







