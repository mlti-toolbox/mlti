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

### Direct Construction
`method = IFTEnum.member`

### Conversion from Character or String Arrays
`method = IFTEnum('memberName')`<br>
`method = IFTEnum("memberName")`

### Creating an `IFTEnum` Enumeration Array
`methods = [IFTEnum.member1,IFTEnum.member2,...]`<br>
`methods = IFTEnum({'memberName1','memberName2',...})`<br>
`methods = IFTEnum(["memberName1","memberName2",...])`

See "[Refer to Enumerations](https://www.mathworks.com/help/matlab/matlab_oop/how-to-refer-to-enumerations.html)" for more details.

## Enumeration Members

<table>
  <tr>
    <td>
      ifft2
    </td>
    <td>
      Use MATLAB's built-in <a href="https://www.mathworks.com/help/matlab/ref/ifft2.html"><code>ifft2</code></a> method
    </td>
  </tr>
  <tr>
    <td>
      integral2
    </td>
    <td>
      Use MATLAB's built-in <a href="https://www.mathworks.com/help/matlab/ref/integral2.html"><code>integral2</code></a> method
    </td>
  </tr>
</table>

## See Also
### MLTI Companion Classes and Methods
[`IFTSolver`](MLTI/Documentation/IFTSolver)

### MATLAB Built-in Methods
[`ifft2`](https://www.mathworks.com/help/matlab/ref/ifft2.html) | [`integral2`](https://www.mathworks.com/help/matlab/ref/integral2.html)

### MATLAB Topics
[Enumerations](https://www.mathworks.com/help/matlab/enumeration-classes.html)<br>
[Refer to Enumerations](https://www.mathworks.com/help/matlab/matlab_oop/how-to-refer-to-enumerations.html)<br>
[Enumerations for Property Values](https://www.mathworks.com/help/matlab/matlab_oop/restrict-property-values-to-enumerations.html)
