
### Layer Creation:

Suppose we have a material layer with three unique principal conductivities: `kp1 > kp2 > kp3`.


To orient the principal axes, we use ZYZ Euler angles: `θZ1`, `θY2`, and `θZ3`.

```matlab
layer = Layer("principal", "euler", "ZYZ")
```

```matlabTextOutput
layer = 
  Layer with properties:

     isotropy: principal
       orient: euler
    euler_seq: ZYZ
     inputStr: ["kp1", "kp2", "kp3", "θZ1", "θY2", "θZ3"]
```


Here, the `inputStr` property tells us that the function `toTensor` will require six arguments: `kp1`, `kp2`, `kp3`, `θZ1`, `θY2`, and `θZ3.`

### Conversion to Tensor with Four Different Orientations:

Consider a layer with four grains, each sharing the same principal conductivities but differing in the orientation of their principal axes:

-  Grain 1: `[p1,p2,p3] = [x,y,z]` (aligned with global coordinate system) 
-  Grain 2: `[p1,p2,p3] = [y,x,z]` 
-  Grain 3: `[p1,p2,p3] = [z,y,x]` 
-  Grain 4: Complex orientation 

The `toTensor` function handles the variablility in orientation automatically, returning a tensor for each grain.

```matlab
kp1 = 10;
kp2 = 5;
kp3 = 2;

% Four orientation angles for each of the four grains
thetaZ1 = deg2rad([0, 90, 0, 30]);
thetaY2 = deg2rad([0, 0, 90, 45]);
thetaZ3 = deg2rad([0, 0, 0, 120]);

% Convert to 6-element tensor
[k11, k21, k31, k22, k32, k33] = layer.toTensor(kp1, kp2, kp3, thetaZ1, thetaY2, thetaZ3);
```

Each element of the tensor is a 1\-by\-4 vector.  We can display the matrix tensor for each grain as follows:

```matlab
for i = 1:length(k11)
    fprintf( ...
        "Tensor when ZYZ Euler angles = [%g, %g, %g] deg:", ...
        rad2deg(thetaZ1(i)), rad2deg(thetaY2(i)), rad2deg(thetaZ3(i)) ...
    )
    K = [k11(i), k21(i), k31(i)
         k21(i), k22(i), k32(i)
         k31(i), k32(i), k33(i)]
end
```

```matlabTextOutput
Tensor when ZYZ Euler angles = [0, 0, 0] deg:
K = 3x3
    10     0     0
     0     5     0
     0     0     2

Tensor when ZYZ Euler angles = [90, 0, 0] deg:
K = 3x3
    5.0000    0.0000         0
    0.0000   10.0000         0
         0         0    2.0000

Tensor when ZYZ Euler angles = [0, 90, 0] deg:
K = 3x3
    2.0000         0   -0.0000
         0    5.0000         0
   -0.0000         0   10.0000

Tensor when ZYZ Euler angles = [30, 45, 120] deg:
K = 3x3
    6.6071   -2.7681   -2.6058
   -2.7681    6.2679    0.2633
   -2.6058    0.2633    4.1250

```


Thus, a single set of principal conductivities can yield multiple grain\-specific tensors simply by varying the Euler angles, providing a flexible way to represent anisotropy in a material layer.

