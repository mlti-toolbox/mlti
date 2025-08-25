classdef IsotropyEnum
% IsotropyEnum - Defines how thermal conductivity is represented and validated
%
% IsotropyEnum is an enumeration class that defines property
% value validation for conductivity representation properties.
%
% IsotropyEnum Enumerations:
%
%   ISOTROPIC  - 1 DOF: isotropic thermal conductivity (k).
%   UNIAXIAL   - 4 DOFs: axial and transverse conductivities (k∥ & k⊥) + symmetry axis orientation.
%   PRINCIPAL  - 6 DOFs: three principal conductivities (kp1 > kp2 > kp3) + principal axes orientation.
%   TENSOR     - 6 DOFs: 6 unique tensor elements (k11, k21, k31, k22, k32, k33).
%
% See also:
% OrientEnum,
% ForwardModel,
% <a href="https://www.mathworks.com/help/matlab/enumeration-classes.html">Enumerations</a>,
% <a href="https://www.mathworks.com/help/matlab/matlab_oop/restrict-property-values-to-enumerations.html">Enumerations for Property Values</a>
% 
% Note: Uniaxial and principal representations require orientation information
% to define the axis of symmetry or principal axes relative to the global frame.

    enumeration
        isotropic, uniaxial, principal, tensor
    end

    properties (Dependent)
        Nk % Number of independent thermal conductivity values for this representation.
    end
    
    methods
        function Nk = get.Nk(obj)
            switch obj
                case IsotropyEnum.isotropic
                    Nk = 1;
                case IsotropyEnum.uniaxial
                    Nk = 2;
                case IsotropyEnum.principal
                    Nk = 3;
                case IsotropyEnum.tensor
                    Nk = 6;
            end
        end
    end
end