
### Layer Creation:

Suppose we have a uniaxially thermally symmetric layer, characterized by:

-  Transverse conductivity (`k⊥`): conductivity in the plane orthogonal to the axis of symmetry. 
-  Axial conductivity (`k∥`): conductivity along the axis of symmetry. 

To orient the axis of symmetry in 3D space, we use unit direction vectors: `v1`, `v2`, `v3`

```matlab
layer = Layer("uni", "uvect") % 'uni' uniquely maps to 'uniaxial'
```

```matlabTextOutput
layer = 
  Layer with properties:

     isotropy: uniaxial
       orient: uvect
    euler_seq: na
     inputStr: ["k⊥", "k∥", "v1", "v2", "v3"]
```


Here, the `inputStr` property tells us that the function `toTensor` will require five arguments: `k⊥`, `k∥`, `v1`, `v2`, and `v3`.

### Conversion to Tensors w.r.t. Three Temperatures and Two Orientations:

Consider a layer with two grains, each sharing the same principal conductivities but differing in the orientation of their principal axes.


Furthermore, suppose we wish to calculate the tensor at three different temperatures.


Since the orientation of the principal axes is independent of temperature, we obtain a total of six tensors:

||||
| :-- | :-- | :-- |
|  | Grain 1  | Grain 2   |
| Temp 1  | K11  | K12   |
| Temp 2  | K21  | K22   |
| Temp 3  | K31  | K32   |

```matlab
k_perp = [20; 25; 30]; % Transverse conductivity at T1, T2, and T3
k_par  = [50; 45; 40]; % Axial conductivity at T1, T2, and T3

% Unit direction vectors for grains 1 and 2
v1 = [1, 1/sqrt(3)];
v2 = [0, 1/sqrt(3)];
v3 = [0, 1/sqrt(3)];

% Convert to 6-element tensor
[k11, k21, k31, k22, k32, k33] = layer.toTensor(k_perp, k_par, v1, v2, v3);
```

Each element of the tensor is a 3\-by\-2 matrix.  We can display the matrix tensor for each temperature\-grain combination as follows:

```matlab
for Ti = 1:size(k11, 1)
    for Oi = 1:size(k11, 2)
        fprintf( ...
            "Tensor when k⊥ = %g, k∥ = %g, and v = [%g, %g, %g]", ...
            k_perp(Ti), k_par(Ti), v1(Oi), v2(Oi), v3(Oi) ...
        )
        K = [k11(Ti, Oi), k21(Ti, Oi), k31(Ti, Oi)
             k21(Ti, Oi), k22(Ti, Oi), k32(Ti, Oi)
             k31(Ti, Oi), k32(Ti, Oi), k33(Ti, Oi)]
    end
end
```

```matlabTextOutput
Tensor when k⊥ = 20, k∥ = 50, and v = [1, 0, 0]
K = 3x3
    50     0     0
     0    20     0
     0     0    20

Tensor when k⊥ = 20, k∥ = 50, and v = [0.57735, 0.57735, 0.57735]
K = 3x3
   30.0000   10.0000   10.0000
   10.0000   30.0000   10.0000
   10.0000   10.0000   30.0000

Tensor when k⊥ = 25, k∥ = 45, and v = [1, 0, 0]
K = 3x3
    45     0     0
     0    25     0
     0     0    25

Tensor when k⊥ = 25, k∥ = 45, and v = [0.57735, 0.57735, 0.57735]
K = 3x3
   31.6667    6.6667    6.6667
    6.6667   31.6667    6.6667
    6.6667    6.6667   31.6667

Tensor when k⊥ = 30, k∥ = 40, and v = [1, 0, 0]
K = 3x3
    40     0     0
     0    30     0
     0     0    30

Tensor when k⊥ = 30, k∥ = 40, and v = [0.57735, 0.57735, 0.57735]
K = 3x3
   33.3333    3.3333    3.3333
    3.3333   33.3333    3.3333
    3.3333    3.3333   33.3333

```


This example shows how uniaxial anisotropy can be efficiently represented across both temperature variations and orientation differences, yielding a complete set of tensors for multi\-grain, multi\-temperature analyses.

