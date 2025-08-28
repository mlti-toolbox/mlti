---
layout: docs
title: Layer Class Documentation
permalink: /Documentation/Layer
---

# Layer

Characterizes a material layer and converts user input into canonical thermal properties.

## Syntax

## Description

## Creation

### Syntax
<hr>

[`layer = Layer()`](#d1)<br>
[`layer = Layer(isotropy)`](#d2)<br>
[`layer = Layer(isotropy,orient)`](#d3)<br>
[`layer = Layer(isotropy,orient,euler_seq)`](#d4)<br>
[`layer = Layer(___,Name,Value)`](#d5)<br>

### Description
<hr>
<a id="d1"></a>
`layer = Layer()` creates a `Layer` object using the default tensor representation of thermal conductivity.
<hr>
<a id="d2"></a>
`layer = Layer(`[`isotropy`](#i1)`)` creates a `Layer` object with a user-specified isotropy type.  
Valid only for `isotropic` and `tensor` representations, since `orient` must also be specified for `uniaxial` and `principal` cases.
<hr>
<a id="d3"></a>
`layer = Layer(`[`isotropy`](#i1)`,`[`orient`](#i2)`)` creates a `Layer` object with a user-specified isotropy type and orientation.  
Valid only for `uniaxial` and `principal` representations, since `orient` is not required for `isotropic` or `tensor`.
<hr>
<a id="d4"></a>
`layer = Layer(`[`isotropy`](#i1)`,`[`orient`](#i2)`,`[`euler_seq`](#i3)`)` creates a `Layer` object with a user-specified isotropy type, orientation, and Euler sequence.  
Valid only when `orient` is `euler`, since `euler_seq` is not required for other orientations.
<hr>
<a id="d5"></a>
`layer = Layer(___,`[`Name,Value`](#i3)`)`
<hr>

### Input Arguments
<a id="i1"></a>
<a id="i2"></a>
<a id="i3"></a>

#### Name-Value Arguments

### Examples


## Properties

## Object Functions

## Examples

## See Also
