---
layout: docs
title: toTensor Function Documentation
permalink: /Documentation/Layer/toTensor
---

# toTensor

## Description

## Creation

### Syntax

<a href="#d1">
<code class="hang">[k11,<wbr>k21,<wbr>k31,<wbr>k22,<wbr>k32,<wbr>k33] = <wbr>toTensor(<wbr>layer,<wbr>&lt;layer.inputStr&gt;)</code>
</a><br>

<a href="#d2">
<code class="hang">[k11,<wbr>k21,<wbr>k31,<wbr>k22,<wbr>k32,<wbr>k33] = <wbr>toTensor(<wbr>layer,<wbr>&lt;layer.inputStr&gt;,<wbr>transform)</code>
</a><br>

Where `<layer.inputStr>` specifies a variable number of inputs, fixed when the `layer` object is constructed.  

**Example:** if `layer.inputStr == ["k⊥","k∥","θ_az","θ_pol"]`, then the construction syntax would be<br>
<code class="hang">[k11,<wbr>k21,<wbr>k31,<wbr>k22,<wbr>k32,<wbr>k33] = <wbr>toTensor(<wbr>layer,<wbr>k⊥,<wbr>k∥,<wbr>θ_az,<wbr>θ_pol,<wbr>transform)</code><br>
where `transform` is an optional argument.

### Description

### Input Arguments

### Name-Value Arguments

## Properties

## Object Functions

## Examples

## See Also
