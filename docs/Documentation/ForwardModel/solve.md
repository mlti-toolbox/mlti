---
layout: docs
title: ForwardModel.solve
permalink: /Documentation/ForwardModel/solve
---

# ForwardModel.solve
Solves the forward model

## Syntax

```matlab
[phi, A, DC] = fm.solve(M, Theta, chi, f0)
[phi, A, DC] = fm.solve(M, Theta, chi, f0, x_probe)
```

## Description

`[phi, A, DC] = fm.solve(M, Theta, chi, f0, x_probe)` solves the forward model and returns the surface thermal response characterized by:  
- **`phi`**: phase  
- **`A`**: amplitude  
- **`DC`**: DC temperature change  

These outputs correspond to the given inputs.  

- If **`x_probe`** is *not* provided (i.e., only four input arguments), the method returns results at each discrete point used in the `ifft2` transform.  
  - This behavior is valid only when `fm.iprops.ift_method = "ifft2"`.  

- If **`x_probe`** *is* provided, the method:  
  - Performs 2D linear interpolation of the `ifft2` results if `fm.iprops.ift_method = "ifft2"`.  
  - Computes the results directly if `fm.iprops.ift_method = "integral2"`.  

---



## Examples

## Input Arguments

`fm.in_structure`

## Output Arguments

## See Also



