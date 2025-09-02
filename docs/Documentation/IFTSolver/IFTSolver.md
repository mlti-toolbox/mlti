---
layout: docs
title: IFTSolver Class Documentation
permalink: /Documentation/IFTSolver
---

# IFTSolver

## Description

## Creation

### Syntax
<a href="#d1"><code class="hang">solver = IFTSolver(<wbr>"integral2")</code></a>

<a href="#d2"><code class="hang">solver = IFTSolver(<wbr>"ifft2",<wbr>"x_max",<wbr>x_max)</code></a><br>
<a href="#d3"><code class="hang">solver = IFTSolver(<wbr>"ifft2",<wbr>"x_max",<wbr>x_max,<wbr>"dx",<wbr>dx)</code></a><br>
<a href="#d4"><code class="hang">solver = IFTSolver(<wbr>"ifft2",<wbr>"x_max",<wbr>x_max,<wbr>"Nx",<wbr>Nx)</code></a><br>
<a href="#d5"><code class="hang">solver = IFTSolver(<wbr>"ifft2",<wbr>"dx",<wbr>dx)</code></a><br>
<a href="#d6"><code class="hang">solver = IFTSolver(<wbr>"ifft2",<wbr>"dx",<wbr>dx,<wbr>"Nx",<wbr>Nx)</code></a>

### Description
<a id="d1"></a>
`solver = IFTSolver(`<wbr>`"integral2")` creates an `IFTSolver` object that uses MATLAB's built-in [`integral2`](https://www.mathworks.com/help/matlab/ref/integral2.html) method to solve the 2-D inverse Fourier transform.
<p>
  \(
    \breve{T}_f \left( x, y, 0, f \right) = 
    \int_{-\infty}^\infty \int_{-\infty}^\infty 
    \hat{T}_f \left( u, v, 0, f \right) \, 
    \exp \left( 2 i \pi \left( u x + v y \right) \right) \, du \, dv
  \)
</p>
<hr>
<a id="d2"></a>

<hr>
<a id="d3"></a>

<hr>
<a id="d4"></a>

<hr>
<a id="d5"></a>

<hr>
<a id="d6"></a>

### Input Arguments

### Name-Value Arguments

## Properties

## Object Functions

## Examples

## See Also
