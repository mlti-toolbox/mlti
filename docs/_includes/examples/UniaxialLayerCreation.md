
### Layer Creation:

Suppose we have a uniaxially thermally symmetric layer, characterized by:

-  Transverse conductivity (`k⊥`): conductivity in the plane orthogonal to the axis of symmetry. 
-  Axial conductivity (`k∥`): conductivity along the axis of symmetry. 

To orient the axis of symmetry in 3D space, we use azimuthal (`θ_az`) and polar (`θ_pol`) angles.

```matlab
layer = Layer("uni", "azpol") % 'uni' uniquely maps to 'uniaxial'
```

```matlabTextOutput
layer = 
  Layer with properties:

     isotropy: uniaxial
       orient: azpol
    euler_seq: na
     inputStr: ["k⊥", "k∥", "θ_az", "θ_pol"]
```


Here, the `inputStr` property tells us that the function `toTensor` will require four arguments: `k⊥`, `k∥`, `θ_az`, and `θ_pol`.

### Conversion to Tensor with Axis Aligned with the z\-axis:
```matlab
k_perp = 20; % Transverse conductivity
k_par  = 50; % Axial conductivity

az  = 0; % Azimuthal Angle
pol = 0; % Polar Angle

% Convert to 6-element tensor
[k11, k21, k31, k22, k32, k33] = layer.toTensor(k_perp, k_par, az, pol);

K = [k11, k21, k31;
     k21, k22, k32;
     k31, k32, k33]
```

```matlabTextOutput
K = 3x3
    20     0     0
     0    20     0
     0     0    50

```


Since the symmetry axis aligns with the z\-axis, the tensor reduces to a diagonal form:

-  `Kxx = K(1,1) = k⊥` 
-  `Kyy = K(2,2) = k⊥` 
-  `Kzz = K(3,3) = k∥` 

This matches intuition: axial conductivity in the z\-direction, transverse conductivity in x– and y\-directions.


We get the same result if we orient the axis of symmerty in the \-z direction.  (The only difference comes from small floating\-point errors introduced by evaluating `sin⁡(π)`).

```matlab
az  = 0;  % Azimuthal Angle
pol = pi; % Polar Angle

% Convert to 6-element tensor
[k11, k21, k31, k22, k32, k33] = layer.toTensor(k_perp, k_par, az, pol);

K = [k11, k21, k31
     k21, k22, k32
     k31, k32, k33]
```

```matlabTextOutput
K = 3x3
   20.0000         0   -0.0000
         0   20.0000         0
   -0.0000         0   50.0000

```

### Conversion to Tensor w/ Axis Oriented Arbitrarily:
```matlab
az  = deg2rad(30); % Azimuthal Angle
pol = deg2rad(45); % Polar Angle

% Convert to 6-element tensor
[k11, k21, k31, k22, k32, k33] = layer.toTensor(k_perp, k_par, az, pol);

K = [k11, k21, k31
     k21, k22, k32
     k31, k32, k33]
```

```matlabTextOutput
K = 3x3
   31.2500    6.4952   12.9904
    6.4952   23.7500    7.5000
   12.9904    7.5000   35.0000

```


Here the conductivity tensor is fully populated with six unique elements, even though the material can be defined by only four parameters (`k⊥`, `k∥`, `θ_az`, `θ_pol`).

