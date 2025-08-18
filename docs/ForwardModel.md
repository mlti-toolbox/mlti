---
layout: docs
title: ForwardModel
hyperlink: /ForwardModel
---

# ForwardModel

Models the surface thermal response due to a harmonic laser heat source

## Description

## Creation

Create a `ForwardModel` object with specified parameter values by using the [`ForwardModel`](/MLTI/ForwardModel/ForwardModel) constructor.

## Properties

<details class="custom-details">
  <summary><b>
    <code>c_args</code> - constructor arguments
  </b></summary>

  <br>

  Struct of input arguments passed into the constructor.
    
  **Data Types:** `struct`

  <br>
  
</details>

<details class="custom-details">
  <summary><b>
    <code>in_structure</code> - input structure
  </b></summary>

  <br>

  Specifies the expected input structure for `M`, `Theta`, and `chi` (inputs to `ForwardModel` functions).

  **Data Type:** 1-by-3 cell array, where each element is a string array

  **Example:** 

  <br>
  
</details>

<details class="custom-details">
  <summary><b>
    <code>in_sizes</code> - input sizes
  </b></summary>

  <br>

  Specifies the expected input sizes for `M`, `Theta`, and `chi` (inputs to `ForwardModel` functions).

  **Data Type:** 1-by-3 array of positive scalar values

  **Example:** 

  <br>
  
</details>

## Object Functions
| Function Name | Summary |
|---------------|---------|
| `solve`       | Solves the forward model |
| `plot`        | Plots the surface thermal response |



## Examples

```fm = ForwardModel(ift_method="ifft2", x_max=25, dx=0.5, scale=1e-6, ___)``` creates a ```ForwardModel``` object that uses MATLAB's built in [`ifft2`](https://www.mathworks.com/help/matlab/ref/ifft2.html) method to solve the 2-D inverse Fourier transform, with spatial vectors ```x = y = -25:0.5:25``` in units of microns and spatial frequency vectors ```u = v = -2:0.04:2``` in units of inverse microns.

## See Also










